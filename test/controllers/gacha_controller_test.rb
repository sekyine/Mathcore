require "test_helper"

class GachaControllerTest < ActionDispatch::IntegrationTest
  test "should get draw" do
    get gacha_draw_url
    assert_response :success
  end
end
