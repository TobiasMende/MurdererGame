class Contract < ActiveRecord::Base
  attr_accessible :game_id, :murderer_id, :victim_id, :executed_at, :proved_at
  belongs_to :game
  belongs_to :murderer, class_name: "User"
  belongs_to :victim, class_name: "User"
  
  
  
end
