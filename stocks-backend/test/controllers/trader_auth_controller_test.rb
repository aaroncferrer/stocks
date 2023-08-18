require "test_helper"

class TraderAuthControllerTest < ActionDispatch::IntegrationTest
  test "should get signup" do
    get trader_auth_signup_url
    assert_response :success
  end

  test "should get login" do
    get trader_auth_login_url
    assert_response :success
  end
end
