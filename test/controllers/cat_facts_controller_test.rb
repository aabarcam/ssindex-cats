require "test_helper"

WebMock.allow_net_connect!

class CatFactsControllerTest < ActionDispatch::IntegrationTest
  test "auth should get access" do
    user = users[0]
    get cat_facts_index_url,
      headers: { Authorization: JWT.encode({ user_id: user.id }, "secret_key") }
    assert_response :success
  end

  test "unauth should get 401" do
    get cat_facts_index_url
    assert_response :unauthorized
  end

  test "should 404 on invalid page" do
    user = users[0]
    get cat_facts_index_url,
      params: { "page": 40 },
      headers: { Authorization: JWT.encode({ user_id: user.id }, "secret_key") }
    assert_response :not_found
  end
end
