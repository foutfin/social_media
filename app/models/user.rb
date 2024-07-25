class User < ApplicationRecord
  before_save { self.email = self.email.downcase }
  validates :email , presence: true , length: {maximum: 255} , format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i } , uniqueness: true
  validates :first_name , presence: true , length: {maximum: 50}
  validates :last_name , presence: true , length: {maximum: 50}
  validates :bio , length: {maximum: 255 }
  validates :password , length:{ minimum: 6} , on: :create
  has_many :posts ,dependent: :destroy do
    def archived
      where("archived = ?", true).order(created_at: :desc)
    end
    def unArchived
      where("archived = ?", false).order(created_at: :desc)
    end
  end
  has_one_attached :avatar
  has_many :followers , class_name: 'Connection' , foreign_key: 'follow_to_id' ,dependent: :destroy
  has_many :following , class_name: 'Connection' , foreign_key: 'follow_by_id' , dependent: :destroy
  has_many :follow_requests , class_name: 'FollowRequest' , foreign_key: 'to_id' , dependent: :destroy do
    def unApproved
      where("approved = ? " , nil)
    end
  end
  has_many :followed_posts , source: :posts ,  through: :following
  has_many :history , class_name: "History" , foreign_key: 'user_id' , dependent: :destroy do
    def withPostId(args)
      where("post_id IN (?)",args)
    end
  end
  has_secure_password
end
