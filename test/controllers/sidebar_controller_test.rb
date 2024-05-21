require "test_helper"

class SidebarControllerTest < ActionDispatch::IntegrationTest
  test "should get show_calendar" do
    get sidebar_show_calendar_url
    assert_response :success
  end
end
