module Entities
  class Follower < Grape::Entity
    expose :user_id do |connection|
      connection.follow_by.id
    end
    expose :user_name do |connection|
      connection.follow_by.username
    end
  end
end
