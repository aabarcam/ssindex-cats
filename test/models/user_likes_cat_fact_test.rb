require "test_helper"

class UserLikesCatFactTest < ActiveSupport::TestCase
  test "row without user should be invalid" do
    relation = UserLikesCatFact.new()
    assert_not relation.valid?
  end

  test "should be valid relation" do
    user = users[0]
    relation = user.user_likes_cat_facts.create(fact_id: 1)
    assert relation.valid?
  end

  test "relation with invalid fact id should be invalid" do
    user = users[0]
    relation = user.user_likes_cat_facts.create(fact_id: -1)
    assert_not relation.valid?
  end

  test "user fact pair should be unique" do
    user = users[0]
    fact_id = 1
    user.user_likes_cat_facts.create!(fact_id: fact_id)
    assert_raises(ActiveRecord::RecordInvalid) do
      user.user_likes_cat_facts.create!(fact_id: fact_id)
    end
  end
end
