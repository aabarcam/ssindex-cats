require "test_helper"

WebMock.allow_net_connect!

class PopularFactsControllerTest < ActionDispatch::IntegrationTest
  test "authenticated should get access" do
    user = users[0]
    get popular_facts_path,
      headers: { Authorization: JWT.encode({ user_id: user.id }, "secret_key") }
    assert_response :success
  end

  test "non authenticated should be forbidden" do
    get popular_facts_path
    assert_response :unauthorized
  end
end
