require "test_helper"

WebMock.allow_net_connect!

class CatFactsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cat_facts_index_url
    assert_response :success
  end
end
