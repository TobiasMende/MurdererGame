class Assignment < ActiveRecord::Base
  attr_accessible :accepted, :game_id, :state, :user_id
  belongs_to :game
  belongs_to :user
  
  
  validates_uniqueness_of :game_id, scope: :user_id
end
