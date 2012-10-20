#encoding: utf-8
class ContractsController < ApplicationController
  
  def execute
    contract = Contract.find(params[:id])
    contract.executed_at = DateTime.now
    if current_user == contract.murderer && contract.save
      flash[:notice] = "Der Mord wurde erfolgreich gemeldet!"
    else
      flash[:error] = "Ein Fehler ist aufgetreten."
    end
      redirect_to :back
  end
  
  def confirm
   contract = Contract.find(params[:id])
   if contract.victim == current_user
      contract.proved_at = DateTime.now
      new_contract = contract.victim.remove_from_contractchain_in(contract.game)
      ContractMailer.contract_accepted(contract, new_contract).deliver
      flash[:notice] = "Der Mord wurd bestätigt. Viel Glück beim nächsten Mal."
      redirect_to game(contract.game)
    else
      flash[:error] = "Du hast keine Berechtigung, um diesen Mord zu bestätigen."
      redirect_to :overview
   end
  end
  
  def reject
    contract = Contract.find(params[:id])
   if contract.victim == current_user
      contract.executed_at = DateTime.now
      contract.save
      ContractMailer.contract_rejected(contract).deliver
      flash[:notice] = "Der Mord wurd zurückgewiesen. Der Mörder wird per E-Mail benachrichtigt."
      redirect_to game(contract.game)
    else
      flash[:error] = "Du hast keine Berechtigung, um diesen Mord zurückzuweisen."
      redirect_to :overview
   end
  end
  
end
