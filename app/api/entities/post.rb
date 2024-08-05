module Entities
  class Media < Grape::Entity
      expose :filename
      expose :url do |media , options|
        media.url
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
  end

end
