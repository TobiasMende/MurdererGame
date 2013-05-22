require 'test_helper'

class OauthControllerTest < ActionController::TestCase
  test "should get init_default" do
    get :init_default
    assert_response :success
  end

  test "should get callback_default" do
    get :callback_default
    assert_response :success
  end

end
