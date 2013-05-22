#encoding: utf-8
class User < ActiveRecord::Base
  COURSES = {"Bachelor Informatik" => "BInf",
    "Bachelor Molecular Life Science" => "BMLS",
    "Bachelor Medizin" => "BMed",
    "Bachelor Biomedical Engineering" => "BBME",
    "Bachelor Infection Biology" => "BInfBio",
    "Bachelor Medizinische Informatik" => "BMI",
    "Bachelor Medizinische Ingeneurwissenschaften" => "BMIW",
    "Bachelor Mathematik in Medizin und Lebenswissenschaften" => "BMML",
    "Master Informatik" => "MInf",
    "Master Molecular Life Science" => "MMLS",
    "Master Medizin" => "MMed",
    "Master Biomedical Engineering" => "MBME",
    "Master Infection Biology" => "MInfBio",
    "Master Medizinische Informatik" => "MMI",
    "Master Medizinische Ingeneurwissenschaften" => "MMIW",
    "Master Mathematik in Medizin und Lebenswissenschaften" => "MMML",
    "Sonstige" => "andere"}.sort
  has_many :assignments
  has_many :games, through: :assignments
  has_many :kill_contracts, :foreign_key => :murderer_id, class_name: "Contract"
  has_many :victim_contracts, :foreign_key => :victim_id, class_name: "Contract"
  has_many :victims, :through => :kill_contracts, :foreign_key => :murderer_id
  has_many :murderers, :through => :victim_contracts, :foreign_key => :victim_id

  attr_accessor :password
  before_save :encrypt_password
  before_save do
    self.email.downcase!
    self.openid_url.downcase!
  end
  before_create :generate_activation
  before_destroy :clear_files
  attr_accessible :course, :email, :first_name, :image, :last_name, :password, :password_confirmation, :email_confirmation, :term, :last_login, :deleted_at, :activation_token, :openid_url, :facebook_id
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>", :large => "800x600" }
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :course
  validates_attachment :image, attachment_presence: true, content_type: {content_type: "image/jpg", content_type: "image/jpeg"}, size: {in: 0..10000.kilobytes}
  validates_presence_of :email, :unless => :openid_url?
  validates_confirmation_of :email, :unless => :openid_url?
  validates_presence_of :password, :on => :create, :unless => :openid_url?
  validates_confirmation_of :password, :unless => :openid_url?
  validates_presence_of :openid_url, :on => :create, :unless => :email?
  validates_uniqueness_of :email
  validates_uniqueness_of :facebook_id, allow_blank: true, allow_nil: true, :case_sensitive => false
  validates_uniqueness_of :openid_url, allow_blank: true, allow_nil: true, :case_sensitive => false
  validates :term, presence: true, numericality: {greater_than_or_equal: 1, only_integer: true}

  def self.authenticate(email, password)
    user = find_by_email(email).first
    if user.nil? || user.password_hash.nil?
      return nil
    end
    if !user.nil? && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt) && user.deleted_at.nil? && user.activation_token.nil?
    user
    else
      nil
    end
  end

  def self.incactive_users(since=2.weeks)
    where("last_login < ?", Date.today - since)
  end

def self.find_by_openid_url(openid_url)
  User.find(:all, :conditions => ["openid_url = lower(?)", openid_url]) 
end
def self.find_by_email(email)
  User.find(:all, :conditions => ["email = lower(?)", email]) 
end

  def last_login
    login = read_attribute(:last_login)
    if login.nil?
      nil
    else
    login.localtime
    end

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

  def activate
    self.activation_token = nil
    self.save!
    UserMailer.activation_confirmed(self).deliver
    true
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

  def victim_contracts_to_prove
    current_victim_contracts.where("executed_at IS NOT NULL")
  end

  def unproved_kill_contracts
    kill_contracts.includes(:game).where("executed_at IS NOT NULL AND proved_at IS NULL").where("games.game_end >= ? OR games.game_end IS NULL", Date.today)
  end

  def suicides_in(game)
    kill_contracts.where("game_id = ? AND victim_id = ?",game,self)
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

  def unproved_kill_contracts_in_game(game)
    unproved_kill_contracts.where("game_id = ?",game)
  end

  def proved_victim_contracts_for_game(game)
    proved_victim_contracts.where("game_id = ?",game)
  end

  def victim_contracts_to_prove_in_game(game)
    victim_contracts_to_prove.where("game_id = ?",game)
  end

  def finished_games
    games.where("game_end < ?", Date.today)
  end

  def future_games
    games.where("game_start > ?", Date.today)
  end

  def status_in_game(game)
    if is_alive_in_game(game)
      "lebendig"
    else
      "getötet"
    end
  end

  def is_alive_in_game(game)
    proved_victim_contracts_for_game(game).empty?
  end

  def long_course
    c = User::COURSES.select{|key, value| value == course}.first
    if c.nil?
      c = User::COURSES.select{|key, value| value == "B"+course}.first
    end
    c[0]
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
    self.current_games.each do |game|
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
      if second.executed_at.nil?
      second.destroy
      else
      second.proved_at = DateTime.now
      second.save
      end

      # check if game is over
      if v == m
      game.handle_game_finished
      return nil
      else
        c = Contract.new
      c.game = game
      c.murderer = m
      c.victim = v
      c.save
      return c
      end
    end
  end

  # Kills the user in a give game.
  # Will remove him from the contractchain
  # and add a new contract where the user is his own murderer.
  # This contract then is allready proved.
  def suicide_in(game)
    g = Game.find(game)
    new_contract = remove_from_contractchain_in(g)
    if !new_contract.nil?
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

  def clear_files
    puts "Deleting Image"
    self.image.destroy
  end
end
