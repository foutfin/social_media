class History < ApplicationRecord
  belongs_to :user
  belongs_to :post
  enum status: { liked: 0 , disliked:1  }
end
