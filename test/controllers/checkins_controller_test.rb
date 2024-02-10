require "test_helper"

class CheckinsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get checkins_index_url
    assert_response :success
  end

  test "should get create" do
    get checkins_create_url
    assert_response :success
  end

  test "should get destroy" do
    get checkins_destroy_url
    assert_response :success
  end
end
