require "test_helper"

class AdminAuthControllerTest < ActionDispatch::IntegrationTest
  test "should get signup" do
    get admin_auth_signup_url
    assert_response :success
  end

  test "should get login" do
    get admin_auth_login_url
    assert_response :success
  end
end
