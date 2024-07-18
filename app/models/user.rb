class User < ApplicationRecord
  before_save { self.email = self.email.downcase }
  Email_regex =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates :email , presence: true , length: {maximum: 255} , format: {with: Email_regex } , uniqueness: true
  validates :username , length: { maximum: 255 } , uniqueness: true
  validates :first_name , presence: true , length: {maximum: 50}
  validates :last_name , presence: true , length: {maximum: 50}
  validates :bio , length: {maximum: 255 }
  validates :password , length:{ minimum: 6}
  has_many :posts
  has_secure_password
end
