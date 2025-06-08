require "test_helper"

WebMock.allow_net_connect!

class CatFactsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cat_facts_index_url
    assert_response :success
  end

  test "should redirect on invalid page" do
    get cat_facts_index_url, params: { "page": 40 }
    assert_redirected_to cat_facts_index_url
  end
end
