class User < ActiveRecord::Base
  COURSES = {"Informatik" => "Inf", "Molecular Life Science" => "MLS", "Medizin" => "Med", "Biomedical Engineering" => "BME", "Infection Biology" => "InfBio", "Medizinische Informatik" => "MI", "Medizinische Ingeneurwissenschaften" => "MIW", "Mathematik in Medizin und Lebenswissenschaften" => "MML"}.sort
  has_many :assignments
  has_many :games, through: :assignments
  has_many :kill_contracts, :foreign_key => :murderer_id, class_name: "Contract"
  has_many :victim_contracts, :foreign_key => :victim_id, class_name: "Contract"
  
  
  attr_accessor :password
  before_save :encrypt_password
 
  attr_accessible :course, :email, :first_name, :image, :last_name, :password, :password_confirmation, :email_confirmation, :term, :last_login
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
  validates :term, presence: true, numericality: {greater_than: 0} 
  
  
   def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
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
  
  def current_games
    games.where("game_start <= ? AND (game_end >= ? OR game_end IS NULL)", Date.today, Date.today)
  end
  
  def current_kill_contracts
    kill_contracts.where("proved_at IS NULL")
  end
  
  def current_victim_contracts
    victim_contracts.where("proved_at IS NULL")
  end
  
  def finished_games
    games.where("game_end < ?", Date.today)
  end
  
  def future_games
    games.where("game_start > ?", Date.today)
  end
  
  def long_course
    User::COURSES.select{|key, value| value == course}.first[0]
  end
  

end
