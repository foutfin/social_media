module Entities
  class Search < Grape::Entity 
    expose :username
    expose :first_name
    expose :last_name
    expose :id
    expose :url do | user , options|
      "/user/#{user.id}"
    end
   end

   class Check < Grape::Entity 
    expose :status
    expose :res , using: Search
   end

end
