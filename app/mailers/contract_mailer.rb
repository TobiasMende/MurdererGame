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
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contract_mailer.contract_rejected.subject
  #
  def contract_rejected(contract)
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contract_mailer.contract_accepted.subject
  #
  def contract_accepted(contract)
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
