#encoding: utf-8
class ContractsController < ApplicationController
  
  def execute
    contract = Contract.find(params[:id])
    if current_user == contract.murderer && contract.execute
      flash[:notice] = "Der Mord wurde erfolgreich gemeldet!"
    else
      flash[:error] = "Ein Fehler ist aufgetreten."
    end
      redirect_to :back
  end
  
  def confirm
   contract = Contract.find(params[:id])
   if contract.victim == current_user
     contract.confirm
      flash[:notice] = "Der Mord wurd bestätigt. Viel Glück beim nächsten Mal."
      redirect_to game_path(contract.game)
    else
      flash[:error] = "Du hast keine Berechtigung, um diesen Mord zu bestätigen."
      redirect_to :overview
   end
  end
  
  def reject
    contract = Contract.find(params[:id])
   if contract.victim == current_user
     contract.reject
      flash[:notice] = "Der Mord wurd zurückgewiesen. Der Mörder wird per E-Mail benachrichtigt."
      redirect_to game_path(contract.game)
    else
      flash[:error] = "Du hast keine Berechtigung, um diesen Mord zurückzuweisen."
      redirect_to :overview
   end
  end
  
end
