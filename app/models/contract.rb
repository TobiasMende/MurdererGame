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
      puts "First murderer = "+m.name+"("+m.id.to_s+")"
      while !m.is_alive_in_game(game) && (m != self.victim)
        m = m.proved_victim_contracts_for_game(self.game).last.murderer
        puts "Next murderer = "+m.name+"("+m.id.to_s+")"
      end
      # reconnect chain m --> victim
      puts "Goto reconnect_chain"
      new_contract = self.reconnect_chain(m)
      if !new_contract.nil?
        puts "New contract = ("+new_contract.murderer_id.to_s+", "+new_contract.victim_id.to_s+") ID: "+new_contract.id.to_s
        ContractMailer.new_contract(new_contract).deliver
      end
    end
    self.proved_at = Time.now
    self.save
    if self.game.open_contracts.empty?
      self.game.handle_game_finished
    end

  end

  def execute
    self.executed_at = DateTime.now
    if self.save
      ContractMailer.contract_executed(self).deliver
      true
    else
      false
    end

  end

  def reject
    self.executed_at = nil
    if self.save
      ContractMailer.contract_rejected(contract).deliver
    end
  end

  def reconnect_chain(new_murderer)
    puts "Reconnecting Chain ..."
    # Contract where the current victim is the murderer
    victims_contract = self.victim.open_kill_contracts_for_game(self.game)

    # New contract connecting current murderer with victims victim

    # Delte old contract of the victim (is can't be executed)
    tmp = victims_contract
    puts "Deleting victim contracts ..."
    victims_contract.each do |c|
      c.destroy
    end
    # Handle game end condition
    if tmp.first.victim == new_murderer
      nil
    else
      puts "Creating new contract"
      new_contract = Contract.new
      new_contract.game = self.game
      new_contract.murderer= new_murderer
      new_contract.victim = tmp.first.victim
      puts "Saving contract ..."
      new_contract.save
      puts "Contract saved."
    new_contract
    end
  end

end
