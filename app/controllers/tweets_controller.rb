class TweetsController < ApplicationController
  before_action :set_twitter_client, only: [:create, :show]

  # BASE_IMAGE_PATH = './app/assets/images/test3.png'.freeze
  # BASE_IMAGE_PATH = @tweet.picture.path
  GRAVITY = 'center'.freeze
  TEXT_POSITION = '0,0'.freeze
  FONT = './app/assets/fonts/font.ttf'.freeze
  ROW_LIMIT = 8

  def reply
    @reply = @twitter.mentions_timeline
    puts @reply
  end

  def new
    @tweet = Tweet.new
    # @twlink = @twitter.user.url.to_s
  end
  
  def create
    @tweet = current_user.tweets.build(tweet_params)

    # @tweet.imageは、この時点で選択しておかないとImage_buildメソッドができないため、ここで判定する
    unless @tweet.image
      flash.now[:danger] = "フレームを選択してください"
      render 'new'
    else
      @tweet.picture = Image_build(@tweet.comment)
      if @tweet.save
        flash[:success] = "ツイートしました"
        @twitter.update_with_media("#ついわく\nhttps://www.tsuiwaku.com/", "#{@tweet.picture.path}")
        redirect_to @tweet
      else
        render 'new'
      end
    end
  end

  def index
    @tweets = Tweet.all
  end

  def show
    @tweet = Tweet.find(params[:id])
    @twlink = @twitter.user.url.to_s
  end

  def Image_build(text)
    text = prepare_text(text)
    @image = MiniMagick::Image.open(@tweet.image)
    configuration(text)
  end

  private

    def set_twitter_client
      @twitter = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_API_KEY"]
        config.consumer_secret     = ENV["TWITTER_API_SECRET_KEY"]
        config.access_token        = Rails.application.message_verifier('secret_key').verify(current_user.token)[:token]
        config.access_token_secret = Rails.application.message_verifier('secret_key').verify(current_user.secret)[:token]
      end
    end

    def tweet_params
      params.require(:tweet).permit(:comment, :picture, :image)
    end

    # 設定関連の値を代入
    def configuration(text)
      @image.combine_options do |config|
        config.font FONT
        config.gravity GRAVITY
        config.pointsize @font_size
        config.draw "text #{TEXT_POSITION} '#{text}'"
      end
    end

    # 背景にいい感じに収まるように文字を調整して返却
    def prepare_text(text)
      if text.length >= 40
        @font_size = 50
        indention_count = 15
      else
        indention_count = 12
        @font_size = 70
      end
      text.scan(/.{1,#{indention_count}}/)[0...ROW_LIMIT].join("\n")
    end
  
end
