require "test_helper"

class VersesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get verses_index_url
    assert_response :success
  end

  test "should get show" do
    get verses_show_url
    assert_response :success
  end
end
