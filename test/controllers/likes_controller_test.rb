require "test_helper"

WebMock.allow_net_connect!

class LikesControllerTest < ActionDispatch::IntegrationTest
  test "authenticated should get index" do
    login users[0]
    get index_likes_path
    assert_response :success
  end

  test "non authenticated should be redirected from index" do
    get index_likes_path
    assert_redirected_to new_session_path
  end

  test "authenticated should be able to like" do
    user = users[0]
    login user
    fact_id = 100
    post create_likes_path, params: { fact_id: fact_id }, headers: { HTTP_REFERER: "/cat_facts/index" }

    # page is reloaded
    assert_redirected_to cat_facts_index_url

    # relation is created
    relation = UserLikesCatFact.find_by(fact_id: fact_id, user_id: user.id)
    assert_not_nil relation
  end

  test "authenticated should be able to remove like" do
    user = users[0]
    login user
    fact_id = 100
    post create_likes_path, params: { fact_id: fact_id }
    delete destroy_likes_path, params: { fact_id: fact_id }, headers: { HTTP_REFERER: "/cat_facts/index" }

    # page is reloaded
    assert_redirected_to cat_facts_index_url

    # relation is deleted
    relation = UserLikesCatFact.find_by(fact_id: fact_id, user_id: user.id)
    assert_nil relation
  end

  test "should not be able to destroy unliked fact" do
    user = users[0]
    login user
    fact_id = 100
    delete destroy_likes_path, params: { fact_id: fact_id }, headers: { HTTP_REFERER: "/cat_facts/index" }

    # page is reloaded
    assert_response :not_found

    # relation is deleted
    relation = UserLikesCatFact.find_by(fact_id: fact_id, user_id: user.id)
    assert_nil relation
  end

  test "non authenticated should not be able to like" do
    fact_id = 100
    post create_likes_path, params: { fact_id: fact_id }
    assert_redirected_to new_session_path
  end

  private

  def login(user)
    post session_path, params: { username: user.username }
  end
end
