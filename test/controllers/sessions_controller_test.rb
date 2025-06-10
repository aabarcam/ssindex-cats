require "test_helper"

WebMock.allow_net_connect!

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new for unauthenticated" do
    get new_session_path
    assert_response :success
  end

  test "should redirect on login" do
    login(users[0])
    assert_redirected_to root_url
  end

  test "should redirect on already authenticated" do
    login(users[0])
    get new_session_path
    assert_redirected_to root_url
  end

  private

  def login(user)
    post session_path, params: { username: user.username }
  end
end
