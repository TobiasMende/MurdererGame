require 'test_helper'

class GameMailerTest < ActionMailer::TestCase
  test "game_started" do
    mail = GameMailer.game_started
    assert_equal "Game started", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "game_finished" do
    mail = GameMailer.game_finished
    assert_equal "Game finished", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "login_needed" do
    mail = GameMailer.login_needed
    assert_equal "Login needed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
