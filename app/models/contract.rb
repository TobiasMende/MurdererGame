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
    if self.victim.unproved_kill_contracts_in_game(self.game).empty? && !self.victim.open_kill_contracts_for_game(self.game).empty?
      # Find next murderer which is alive:
      m = self.murderer
      while !m.is_alive_in_game(game) && !(m == self.victim)
        m = m.proved_victim_contracts_for_game(self.game).last.murderer
      end
    # reconnect chain m --> victim
    new_contract = self.reconnect_chain(m)
    ContractMailer.new_contract(new_contract).deliver
    end
    self.proved_at = Time.now
    self.save
  # new_contract = self.reconnect_chain
  # if !new_contract.nil?
  # ContractMailer.contract_accepted(self, new_contract).deliver
  # end
  end



  def reconnect_chain(new_murderer)
    # Contract where the current victim is the murderer
    victims_contract = self.victim.open_kill_contracts_for_game(self.game)

    # New contract connecting current murderer with victims victim

    # Delte old contract of the victim (is can't be executed)
    tmp = victims_contract
    victims_contract.delete
    # Handle game end condition
    if tmp.victim == new_murderer
      self.game.handle_game_finished
      nil
    else
      new_contract = Contract.new
    new_contract.game = self.game
    new_contract.murderer= new_murderer
    new_contract.victim = tmp.victim

    new_contract.save
    new_contract
    end
  end

end
