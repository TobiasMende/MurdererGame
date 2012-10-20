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
  
  def proved_contracts
    contracts.where("proved_at <= ?", DateTime.now)
  end
  
  def open_contracts
    contracts.where("proved_at IS NULL")
  end
  
    def handle_game_end_by_date
    if !self.finished? && self.game_end? && self.game_end == Date.today - 1.days
      handle_game_finished
    end
  end
  
  def handle_game_start_by_date 
    if !self.started? && self.game_start? && self.game_start == Date.today
      create_murder_cycle
      assignments.each do |assignment|
        GameMailer.game_started(assignment).deliver
      end
    end
  end
  
  def handle_game_finished
    self.game_end = Date.today
    self.finished = true
    save!
    assignments.each do |assignment|
        GameMailer.game_finished(assignment).deliver
      end
  end
  
  def create_murder_cycle
    shuffled = self.assignments.shuffle
    if shuffled.size > 0
      for i in 0..(shuffled.size-2) do
        a = shuffled[i].user
        b = shuffled[i+1].user
        Contract.new_contract(self,a,b)
      end
      Contract.new_contract(self,shuffled[shuffled.size-1], shuffled[0])
    end
  end
  
  def winner
    highscore.first
  end
  
  def highscore
    score = users.all.sort_by{|user| user.proved_kill_contracts_for_game(self).count}
    living = score.find{|user| user.proved_victim_contracts_for_game(self).count == 0}
    
    living.each do |user|
      score.delete(user)
      score.unshift(user)
    end
    
    score
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