class FollowRequest < ApplicationRecord
  belongs_to :from , class_name: 'User' 
  belongs_to :to , class_name: 'User'
  validates :from , presence: true , :uniqueness => { :scope => :to }
  validates :to , presence: true 
end
