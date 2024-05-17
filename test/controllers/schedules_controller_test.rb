require "test_helper"

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get schedules_new_url
    assert_response :success
  end

  test "should get create" do
    get schedules_create_url
    assert_response :success
  end

  test "should get edit" do
    get schedules_edit_url
    assert_response :success
  end
end
