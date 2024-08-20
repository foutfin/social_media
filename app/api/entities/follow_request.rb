module Entities
  class FollowRequest < Grape::Entity
    expose :id
    expose :user_id do |fr|
      fr.from_id
    end
    expose :user_name do |fr|
      fr.from.username
    end
  end
end
