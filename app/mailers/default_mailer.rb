#encoding: utf-8
class DefaultMailer < ActionMailer::Base
  default from: "noreply@xn--epic-mrderspiel-etb.de"
  default content_type: "text/html"
  layout "email"
  default from: quote_if_necessary(APP_CONFIG["default_name"], "utf-8") + " <" + APP_CONFIG["from_mail"]+">"
end
