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
    # TODO get contract by id and set prove date
  end
  
  def reject
    # TODO get contract by id and reset execution date
  end
  
end
