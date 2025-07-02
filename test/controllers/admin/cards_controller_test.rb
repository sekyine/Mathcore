require "test_helper"

class Admin::CardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_cards_index_url
    assert_response :success
  end

  test "should get import_csv" do
    get admin_cards_import_csv_url
    assert_response :success
  end
end
