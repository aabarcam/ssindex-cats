require "test_helper"

WebMock.allow_net_connect!

class PopularFactsControllerTest < ActionDispatch::IntegrationTest
  test "authenticated should get index" do
    login users[0]
    get popular_facts_path
    assert_response :success
  end

  test "non authenticated should be redirected from index" do
    get popular_facts_path
    assert_redirected_to new_session_path
  end

  private

  def login(user)
    post session_path, params: { username: user.username }
  end
end
