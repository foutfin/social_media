module Entities
  class Media < Grape::Entity
      expose :filename
      expose :url do |media , options|
        media.url
      end
      expose :type do |media|
        media.content_type
      end
  end

  class Creator < Grape::Entity
    expose :id 
    expose :username
    expose :avatar do |user|
      user.avatar.url
    end
  end
  
  class Post < Grape::Entity
    expose :id
    expose :caption
    expose :body
    expose :media, using: Media
    expose :likes
    expose :dislikes
    expose :created_at
    expose :updated_at
    expose :user , using: Creator
  end

end
