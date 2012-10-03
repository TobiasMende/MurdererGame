class ContractsController < ApplicationController
  
  def execute
    contract = Contract.find(params[:id])
    contract.execute
    redirect_to :back, notice: "Der Mord wurde erfolgreich gemeldet!"
  end
  
end
