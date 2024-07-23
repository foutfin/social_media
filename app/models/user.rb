class User < ApplicationRecord
  before_save { self.email = self.email.downcase }
  validates :email , presence: true , length: {maximum: 255} , format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i } , uniqueness: true
  validates :username , presence:true , length: { maximum: 255 } , format:{with: /\A[a-zA-Z0-9_]/ } ,uniqueness: true 
  validates :first_name , presence: true , length: {maximum: 50}
  validates :last_name , presence: true , length: {maximum: 50}
  validates :bio , length: {maximum: 255 }
  validates :password , length:{ minimum: 6} , on: :create
  has_many :posts
  has_one_attached :avatar
  has_secure_password
end
