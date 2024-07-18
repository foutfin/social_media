class Post < ApplicationRecord
  belongs_to :user
  validates :caption , length: {maximum: 255}, presence: true
end
