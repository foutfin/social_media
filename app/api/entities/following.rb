module Entities
  class Following < Grape::Entity
    expose :user_id do |connection|
      connection.follow_to.id
    end
    expose :user_name do |connection|
      connection.follow_to.username
    end
  end
end
