require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "confirmation_needed" do
    mail = UserMailer.confirmation_needed
    assert_equal "Confirmation needed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "activation_confirmed" do
    mail = UserMailer.activation_confirmed
    assert_equal "Activation confirmed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "new_password" do
    mail = UserMailer.new_password
    assert_equal "New password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "information_update_request" do
    mail = UserMailer.information_update_request
    assert_equal "Information update request", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
