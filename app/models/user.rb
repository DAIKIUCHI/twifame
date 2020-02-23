class User < ApplicationRecord
  # before_action :self.dummy_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tweets, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
  
    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        image: auth.info.image,
        name: auth.info.name,
        nickname: auth.info.nickname,
        location: auth.info.location,
        token: Rails.application.message_verifier('secret_key').generate({ token: auth.credentials.token }),
        secret: Rails.application.message_verifier('secret_key').generate({ token: auth.credentials.secret })
      )
    end
  
    user
  end
  
  private
  
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end

Rails.application.message_verifier('secret_key').generate({ token: 'i am bob' })
