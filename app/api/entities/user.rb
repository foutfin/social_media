module Entities
  class User < Grape::Entity
    expose :username
    expose :first_name
    expose :last_name
    expose :user_id do |user|
      user.id
    end
    expose :email
    expose :bio
    expose :created_at
    expose :updated_at
  end
end
