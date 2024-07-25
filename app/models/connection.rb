class Connection < ApplicationRecord
  belongs_to :follow_by , class_name: 'User' 
  belongs_to :follow_to , class_name: 'User'
  has_many :posts , foreign_key: 'user_id' , primary_key: 'follow_to_id'
end
