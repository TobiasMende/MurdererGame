class DefaultMailer < ActionMailer::Base
  default from: "from@example.com"
  default content_type: "text/html"
  layout "email"
  default from: APP_CONFIG["default_name"] + " <" + APP_CONFIG["from_mail"]+">"
end
