class Post < ApplicationRecord
  belongs_to :user
  validates :caption , length: {maximum: 255}, presence: true
  has_many_attached :media
  validates :media, attached: true, content_type: ['image/png' ,'image/jpg', 'image/jpeg', 'image/avif','image/heif', 'video/mp4'] , size: { less_than: 100.megabytes }
end
