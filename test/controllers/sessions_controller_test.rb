require "test_helper"

WebMock.allow_net_connect!

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # test "should get new for unauthenticated" do
  #   get new_session_path
  #   assert_response :success
  # end

  test "should redirect on login" do
    user = users[0]
    post session_path, params: { username: user.username }
    assert_response :accepted
  end

  # test "should redirect on already authenticated" do
  #   user = users[0]
  #   post session_path, params: { username: user.username },
  #                     headers: { Authorization: JWT.encode({ user_id: user.id }, "secret_key") }
  #   get new_session_path
  #   assert_equal "/", response.headers["Location"]
  #   assert_response :found
  # end
end
