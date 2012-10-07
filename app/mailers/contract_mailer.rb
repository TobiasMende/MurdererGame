class ContractMailer < DefaultMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contract_mailer.new_contract.subject
  #
  def new_contract(contract)
    @contract = contract
    mail(to: contract.murderer.email, subject: APP_CONFIG["subject_prefix"]+contract.game.title+" - Ein neues Mordziel!") 
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contract_mailer.contract_executed.subject
  #
  def contract_executed(contract)
    @contract = contract
    mail(to: contract.victim.email, subject: APP_CONFIG["subject_prefix"]+contract.game.title+" - Du wurdest ermordet!") 
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contract_mailer.contract_rejected.subject
  #
  def contract_rejected(contract)
    @contract = contract
    @support_mail = APP_CONFIG["support_mail"]
    mail(to: contract.murderer.email, subject: APP_CONFIG["subject_prefix"]+contract.game.title+" - Mord abgelehnt!") 
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contract_mailer.contract_accepted.subject
  #
  def contract_accepted(contract, new_contract)
    @contract = contract
    @new_contract = new_contract
    mail(to: contract.murderer.email, subject: APP_CONFIG["subject_prefix"]+contract.game.title+" - Mord bestätigt") 
  end
end
