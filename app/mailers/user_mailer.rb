#encoding: utf-8
class UserMailer < DefaultMailer
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirmation_needed.subject
  #
  def confirmation_needed(user)
    @user = user
    mail(to: user.email, subject: APP_CONFIG["subject_prefix"]+" Deine Anmeldung bei "+APP_CONFIG["domain"])    
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_confirmed.subject
  #
  def activation_confirmed(user)
    @user = user
    @support_mail = APP_CONFIG["support_mail"]
    mail(to: user.email, subject: APP_CONFIG["subject_prefix"]+" Anmeldebestätigung") 
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_password.subject
  #
  def new_password(user, password)
    @user = user
    @password = password
    mail(to: user.email, subject: APP_CONFIG["subject_prefix"]+" Dein neues Passwort") 
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.information_update_request.subject
  #
  def information_update_request(user)
    @user = user
    mail(to: user.email, subject: APP_CONFIG["subject_prefix"]+" Bitte prüfe deine Daten") 
  end
  
  
  def login_needed(user)
    @user = user
    mail(to: user.email, subject: APP_CONFIG["subject_prefix"]+" Noch dabei?") 
  end
  
  
  def user_snitched(user, reason, snitch)
    @user = user
    @reason = reason
    @snitch = snitch
    mail(to: APP_CONFIG["support_mail"].to_iso, subject: "Profil gemeldet: "+user.name+" (ID: "+user.id.to_s+")") 
  end
end
