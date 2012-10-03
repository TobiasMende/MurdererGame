class Contract < ActiveRecord::Base
  attr_accessible :game_id, :murderer_id, :victim_id, :executed_at, :proved_at
  belongs_to :game
  belongs_to :user, :foreign_key => :murderer_id, class_name: "User"
  belongs_to :user, :foreign_key => :victim_id, class_name: "User"
end
