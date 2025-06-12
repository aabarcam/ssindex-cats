require "test_helper"

WebMock.allow_net_connect!

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "should get new for unauthenticated" do
  #   get new_user_path
  #   assert_response :success
  # end

  test "should accept on register" do
    username = "testusername"
    post user_path, params: { username: username }
    assert_response :created
  end

  test "should not allow same user to register" do
    user = users[0]
    post user_path, params: { username: user.username }
    assert_response :unauthorized
  end

  # test "should redirect on already authenticated" do
  #   login users[0]
  #   get new_user_path
  #   assert_redirected_to root_url
  # end

  # private

  # def login(user)
  #   post session_path, params: { username: user.username }
  # end

  # def register(username)
  #   post user_path, params: { username: username }
  # end
end
