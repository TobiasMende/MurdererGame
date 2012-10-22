#encoding: utf-8
class DefaultMailer < ActionMailer::Base
  default from: "noreply@epic-mörderspiel.de"
  default content_type: "text/html"
  layout "email"
  default from: APP_CONFIG["default_name"] + " <" + APP_CONFIG["from_mail"]+">"
end
