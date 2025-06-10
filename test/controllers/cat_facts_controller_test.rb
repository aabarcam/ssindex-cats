require "test_helper"

WebMock.allow_net_connect!

class CatFactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users[0]
    login @user
  end
  test "should get index" do
    get cat_facts_index_url
    assert_response :success
  end

  test "should redirect on invalid page" do
    get cat_facts_index_url,
      params: { "page": 40 }
    assert_redirected_to cat_facts_index_url
  end

  private

  def login(user)
    post session_path, params: { username: user.username }
  end
end
