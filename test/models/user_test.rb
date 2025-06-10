require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user without username should be invalid" do
    user = User.new()
    assert_not user.valid?
  end

  test "should be valid user" do
    count = User.count.to_s
    user = User.new(username: "johndoe" + count)
    assert user.valid?
  end

  test "repeated user should be invalid" do
    count = User.count.to_s
    user1 = User.new(username: "johndoe" + count)
    user1.save
    user2 = User.new(username: "johndoe" + count)
    assert_not user2.valid?
  end

  test "likes? should be true on liked fact" do
    user = users[0]
    fact_id = 1
    user.user_likes_cat_facts.create(fact_id: fact_id)
    assert user.likes?(fact_id)
  end

  test "likes? should be false on non liked fact" do
    user = users[0]
    fact_id = 1
    assert_not user.likes?(fact_id)
  end
end
