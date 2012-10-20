class GameMailer < DefaultMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.game_mailer.game_started.subject
  #
  def game_started(assignment)
    @assignment = assignment
    mail(to: assignment.user.email, subject: APP_CONFIG["subject_prefix"]+assignment.game.title+" - Möge das Spiel beginnen!") 
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.game_mailer.game_finished.subject
  #
  def game_finished(assignment)
    @assignment = assignment
    mail(to: assignment.user.email, subject: APP_CONFIG["subject_prefix"]+assignment.game.title+" - Das Spiel ist beendet!") 
  end

  
end
