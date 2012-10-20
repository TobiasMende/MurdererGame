#encoding: utf-8
class User < ActiveRecord::Base
  COURSES = {"Informatik" => "Inf", "Molecular Life Science" => "MLS", "Medizin" => "Med", "Biomedical Engineering" => "BME", "Infection Biology" => "InfBio", "Medizinische Informatik" => "MI", "Medizinische Ingeneurwissenschaften" => "MIW", "Mathematik in Medizin und Lebenswissenschaften" => "MML"}.sort
  has_many :assignments
  has_many :games, through: :assignments
  has_many :kill_contracts, :foreign_key => :murderer_id, class_name: "Contract"
  has_many :victim_contracts, :foreign_key => :victim_id, class_name: "Contract"
  has_many :victims, :through => :kill_contracts, :foreign_key => :murderer_id
  has_many :murderers, :through => :victim_contracts, :foreign_key => :victim_id
  
  
  
  attr_accessor :password
  before_save :encrypt_password
  before_create :generate_activation
 
  attr_accessible :course, :email, :first_name, :image, :last_name, :password, :password_confirmation, :email_confirmation, :term, :last_login, :deleted_at, :activation_token
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", :large => "800x600" }
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :course
  validates_attachment :image, attachment_presence: true, content_type: {content_type: "image/jpg", content_type: "image/jpeg"}, size: {in: 0..1000.kilobytes}
  validates_presence_of :email
  validates_confirmation_of :email
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_uniqueness_of :email
  validates :term, presence: true, numericality: {greater_than_or_equal: 1, only_integer: true} 
  
  
   def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt) && user.deleted_at.nil? && user.activation_token.nil?
      user
    else
      nil
    end
  end
  
  def self.incactive_users(since=2.weeks)
    where("last_login < ?", Date.today - since)
  end
  
  def name
    first_name+" "+last_name
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def generate_activation
    self.activation_token = SecureRandom::hex(50)
  end
  
  def reset_password
    self.password = SecureRandom::base64(8)
    self.password_confirmation = self.password
  end
  
  
  
  def current_games
    games.where("game_start <= ? AND (game_end >= ? OR game_end IS NULL) AND finished <> ?", Date.today, Date.today, true)
  end
  
  def current_kill_contracts
    kill_contracts.includes(:game).where("executed_at IS NULL").where("games.game_end >= ? OR games.game_end IS NULL", Date.today)
  end

  def current_victim_contracts
    victim_contracts.includes(:game).where("proved_at IS NULL").where("games.game_end >= ? OR games.game_end IS NULL", Date.today)
  end
  
  def proved_kill_contracts
    kill_contracts.where("proved_at IS NOT NULL")
  end
  
  def proved_victim_contracts
    victim_contracts.where("proved_at IS NOT NULL")
  end
  
  
  def open_kill_contracts_for_game(game)
    current_kill_contracts.where("game_id = ?", game)
  end
  
  def proved_kill_contracts_for_game(game)
    proved_kill_contracts.where("game_id = ?", game)
  end
  
  def proved_victim_contracts_for_game(game)
    proved_victim_contracts.where("game_id = ?",game)
  end
  
  def finished_games
    games.where("game_end < ?", Date.today)
  end
  
  def future_games
    games.where("game_start > ?", Date.today)
  end
  
  def status_in_game(game)
    if proved_victim_contracts_for_game(game).empty?
      "lebendig"
    else
      "getötet"
    end
  end
  
  def long_course
    User::COURSES.select{|key, value| value == course}.first[0]
  end
  
  def update_without_confirmation(params={})
    params.delete(:password) if params[:password_confirmation].blank?
    params.delete(:password_confirmation) if params[:password].blank?
    params.delete(:email) if params[:email_confirmation].blank?
    params.delete(:email_confirmation) if params[:email_confirmation].blank?
    update_attributes(params)
   end
   
   def destroy
     assignments.includes(:game).where("games.game_start > ?", Date.today).destroy_all
     current_games.each do |game|
       new_contract = remove_from_contractchain_in(game)
       ContractMailer.new_contract(new_contract).deliver
     end
     update_attribute("deleted_at", DateTime.now)
   end

  # Remove this user from the contracts in a given game.
  # Creates a new contract with his murderer and victim.
  def remove_from_contractchain_in(game)
    first = game.open_contracts.where("murderer_id = ?", self).first
    second = game.open_contracts.where("victim_id = ?", self).first
    if first != nil && second != nil
      v = first.victim
      m = second.murderer
      first.destroy
      second.destroy
      c = Contract.new
      c.game = game
      c.murderer = m
      c.victim = v
      c.save
      c
    end
  end

  # Kills the user in a give game.
  # Will remove him from the contractchain
  # and add a new contract where the user is his own murderer.
  # This contract then is allready proved.
  def suicide_in(game)
    g = Game.find(game)
    new_contract = remove_from_contractchain_in(g)
    if new_contract
      ContractMailer.new_contract(new_contract).deliver
    end
    c = Contract.new
    c.game = g
    c.murderer = self
    c.victim = self
    c.executed_at = DateTime.now
    c.proved_at = DateTime.now
    c.save
  end
end
