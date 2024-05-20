require "test_helper"

class CustomSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get custom_sessions_new_url
    assert_response :success
  end

  test "should get create" do
    get custom_sessions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get custom_sessions_destroy_url
    assert_response :success
  end
end
