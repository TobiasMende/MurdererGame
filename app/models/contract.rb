class Contract < ActiveRecord::Base
  attr_accessible :game_id, :murderer_id, :victim_id, :executed_at, :proved_at
  belongs_to :game
  belongs_to :murderer, class_name: "User"
  belongs_to :victim, class_name: "User"

  validates_uniqueness_of :murderer_id, :scope => [:game_id, :victim_id]
  validates_presence_of :game_id
  validates_presence_of :victim_id
  validates_presence_of :murderer_id  
 
 
  def self.new_contract(game, murderer, victim)
      c = Contract.new
      c.murderer= murderer
      c.victim= victim
      c.game= game
      c.save!
      c
  end
  
  def confirm
    new_contract = self.reconnect_chain
    if !new_contract.nil?
      puts contract.game.title
      ContractMailer.contract_accepted(self, new_contract).deliver
    end
  end
  
  def reconnect_chain
    # Contract where the current victim is the murderer
    victims_contract = self.victim.current_kill_contracts.where("game_id = ?", self.game).first
    
    # New contract connecting current murderer with victims victim
    
    
    # Delte old contract of the victim (is can't be executed)
    
    # Handle game end condition
    if victims_contract.victim.equal?(self.murderer)
      self.game.handle_game_finished
      nil
    else
      new_contract = Contract.new
    new_contract.game = self.game
    new_contract.murderer= self.murderer
    new_contract.victim = victims_contract.victim
    victims_contract.delete
      self.proved_at = Time.now
      self.save
      new_contract.save
      new_contract
    end
  end
  
 end
