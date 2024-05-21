require "test_helper"

class CustomizeControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get customize_edit_url
    assert_response :success
  end

  test "should get update" do
    get customize_update_url
    assert_response :success
  end
end
