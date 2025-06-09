require "test_helper"

class UserLikesCatFactTest < ActiveSupport::TestCase
  test "invalid row without user" do
    relation = UserLikesCatFact.new()
    assert_not relation.valid?
  end

  test "valid relation" do
    user = users[0]
    relation = user.user_likes_cat_facts.create(fact_id: 1)
    assert relation.valid?
  end

  test "invalid relation fact id" do
    user = users[0]
    relation = user.user_likes_cat_facts.create(fact_id: -1)
    assert_not relation.valid?
  end
end
