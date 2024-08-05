module Api
  module Entities
   class Test < Grape::Entity 
    expose :status
    expose :res , using: Search
   end

   class Search < Grape::Entity 
    expose :username
    expose :first_name
    expose :last_name
    expose :id
   end

  end
end
