ActionMailer::Base.smtp_settings = {
 :address               => "mail.tobsolution.de",
 :domain                => "tobsolution.de",
 :port                 => 587, 
 :authentication        => :plain,
 :user_name             => "emgtest@tobsolution.de",
 :password              => "test",
 :openssl_verify_mode  => 'none',
 :enable_starttls_auto => false
}