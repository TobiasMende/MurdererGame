require 'test_helper'

class OpenidControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get begin" do
    get :begin
    assert_response :success
  end

  test "should get complete" do
    get :complete
    assert_response :success
  end

  test "should get openid_consumer" do
    get :openid_consumer
    assert_response :success
  end

end
