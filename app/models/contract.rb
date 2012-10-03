class Contract < ActiveRecord::Base
  attr_accessible :game_id, :murderer_id, :victim_id, :executed_at, :proved_at
  belongs_to :game
  belongs_to :murderer, class_name: "User"
  belongs_to :victim, class_name: "User"

  validates_uniqueness_of :murderer_id, :scope => [:game_id, :victim_id]
  validates_presence_of :game_id
  validates_presence_of :victim_id
  validates_presence_of :murderer_id  
end
