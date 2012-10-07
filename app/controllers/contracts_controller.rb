class ContractsController < ApplicationController
  
  def execute
    contract = Contract.find(params[:id])
    contract.executed_at = DateTime.now
    if current_user == contract.murderer && contract.save
      redirect_to :back, notice: "Der Mord wurde erfolgreich gemeldet!"
    else
      redirect_to :back, error: "Ein Fehler ist aufgetreten."
    end
  end
  
  def confirm
   contract = Contract.find(params[:id])
   if contract.victim == current_user
      contract.proved_at = DateTime.now
      new_contract = contract.victim.remove_from_contractchain_in(contract.game)
      ContractMailer.contract_accepted(contract, new_contract).deliver
      redirect_to game(contract.game), notice: "Der Mord wurd bestätigt. Viel Glück beim nächsten Mal."
    else
      redirect_to :overview, error: "Du hast keine Berechtigung, um diesen Mord zu bestätigen."
   end
  end
  
  def reject
    contract = Contract.find(params[:id])
   if contract.victim == current_user
      contract.executed_at = DateTime.now
      contract.save
      ContractMailer.contract_rejected(contract).deliver
      redirect_to game(contract.game), notice: "Der Mord wurd zurückgewiesen. Der Mörder wird per E-Mail benachrichtigt."
    else
      redirect_to :overview, error: "Du hast keine Berechtigung, um diesen Mord zurückzuweisen."
   end
  end
  
end
