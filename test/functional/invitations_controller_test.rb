require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  test "should get init_facebook_invite" do
    get :init_facebook_invite
    assert_response :success
  end

  test "should get facebook_invite_callback" do
    get :facebook_invite_callback
    assert_response :success
  end

  test "should get email_invitation" do
    get :email_invitation
    assert_response :success
  end

end
