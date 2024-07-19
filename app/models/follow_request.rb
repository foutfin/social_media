class FollowRequest < ApplicationRecord
  belongs_to :from , class_name: 'User' 
  belongs_to :to , class_name: 'User'
  validates :from , presence: true 
  validates :to , presence: true , uniqueness:true
end
