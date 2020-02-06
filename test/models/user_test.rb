require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "aaa@aaa.com", 
                     provider: "twitter", 
                     name: "uchi",
                     nickname: "uuu",
                     password: "1111111111")
  end

  test "user" do
    assert @user.valid?
  end

  test "associated tweets should be destroyed" do
    @user.save
    @user.tweets.create!(comment:"comment", content: "content")
    assert_difference 'Tweet.count', -1 do
      @user.destroy
    end
  end
end
