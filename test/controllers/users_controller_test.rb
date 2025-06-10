require "test_helper"

WebMock.allow_net_connect!

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new for unauthenticated" do
    get new_user_path
    assert_response :success
  end

  test "should redirect on register" do
    register "new_user_test"
    assert_redirected_to new_session_path
  end

  test "should redirect to same on user exists" do
    register users[0].username
    assert_redirected_to user_path
  end

  test "should redirect on already authenticated" do
    login users[0]
    get new_user_path
    assert_redirected_to root_url
  end

  private

  def login(user)
    post session_path, params: { username: user.username }
  end

  def register(username)
    post user_path, params: { username: username }
  end
end
