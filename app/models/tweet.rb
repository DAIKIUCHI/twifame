class Tweet < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :comment, presence: true, length: { maximum: 100 }
  validates :image, presence: true
  validates :picture, presence: true
end
