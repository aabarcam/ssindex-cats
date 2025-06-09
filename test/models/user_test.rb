require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "invalid user without username" do
    user = User.new()
    assert_not user.valid?
  end

  test "valid user" do
    count = User.count.to_s
    user = User.new(username: "johndoe" + count)
    assert user.valid?
  end

  test "invalid repeated user" do
    count = User.count.to_s
    user1 = User.new(username: "johndoe" + count)
    user1.save
    user2 = User.new(username: "johndoe" + count)
    assert_not user2.valid?
  end
end
