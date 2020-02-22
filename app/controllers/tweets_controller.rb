class TweetsController < ApplicationController
  before_action :set_twitter_client, only: [:create]

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
    # @tweet_text = params[:content]
  end
  
  def create
    @tweet = current_user.tweets.build(tweet_params)
    @tweet.picture = Image_build(@tweet.comment)
    @tweet.save
    flash[:success] = "でけた"
    @twitter.update_with_media("", "#{@tweet.picture.path}")
    redirect_to @tweet
  end

  def test
    # images = []
    # images << File.new('./public/uploads/tweet/picture/12/mini_magick20200118-57398-148xxil.png')

    # res = @twitter.update_with_media("test #{Time.now}", images)
    # puts res
  end


  def index
    @tweets = Tweet.all
  end

  def show
    @tweet = Tweet.find(params[:id])
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
        config.access_token        = current_user.token
        config.access_token_secret = current_user.secret
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
          if text.length >= 90
            @font_size = 20
            indention_count = 40
          else
            indention_count = 20
            @font_size = 40
          end
          text.scan(/.{1,#{indention_count}}/)[0...ROW_LIMIT].join("\n")
        end
  
end
