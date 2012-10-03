#encoding: utf-8
class Game < ActiveRecord::Base
  has_many :assignments
  has_many :users, through: :assignments
  has_many :contracts
  
  attr_accessible :assignment_end, :assignment_start, :description, :game_end, :game_start, :max_player, :min_player, :needs_confirmation, :title, :free_places
  attr_accessor :free_places
  
  validates_presence_of :title
  #validates_presence_of :assignment_start
  #validates_presence_of :assignment_end
  validates_presence_of :game_start
  #validate :date_validation
  
  def self.open_games
    #where("assignment_start <= ? AND assignment_end >= ?", Date.today, Date.today)
    where("started <> ?", true)
    #TODO handle max_player
  end
  
  def free_places
    max_player - assignments.count
  end
  
  
  def joinable?(user)
    (free_places != 0 && !started? && users.where("user_id = ?", user).empty?)
  end
  
  # def assignment_phase?
    # Date.today >= assignment_start && Date.today <= assignment_end
  # end
#   
  # def game_phase?1
    # Date.today >= game_start && Date.today <= game_end
  # end
#   
#   
  # def date_validation
    # if assignment_start > assignment_end && (game_end.present? && game_start > game_end)
      # errors.add(:assignment_start, "Startdatum darf nicht größer als Enddatum sein.")
    # end 
    # if(assignment_end > game_start)
      # errors.add(:game_start, "Bei Spielbeginn muss die Registrierung abgeschlossen sein.")
    # end
  # end
end
