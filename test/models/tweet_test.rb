require 'test_helper'

class TweetTest < ActiveSupport::TestCase

  def setup
    @user = User.new(email: "aaa@aaa.com",
                     provider: "twitter",
                     name: "uchi",
                     nickname: "uuu",
                     password: "1111111111")
    @user.save
    @tweet = @user.tweets.build(comment:"comment", content: "content")
  end

  test "should be valid" do
    assert @tweet.valid?
  end

  test "user id should be present" do
    @tweet.user_id = nil
    assert_not @tweet.valid?
  end

  test "order should be most recent first" do
    assert_equal tweets(:most_recent), Tweet.first
  end

end
