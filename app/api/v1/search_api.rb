module V1
  class SearchApi < Grape::API
    helpers Helper::SearchHelpers
    helpers Helper::AuthHelpers
    helpers Helper::CacheHelpers
    helpers Helper::ResponseHelpers
    
    namespace :search do  
      before do
        authenticate
      end
      
      params do
        requires :query, type: String
        optional :limit , type: Integer
        optional :page , type: Integer
        optional :sortby , type: String , values:['date']
      end
      get do
        search_result = search_users params[:query] , params[:page] , params[:limit],params[:sortby]
        generate_response_with_page search_result , Entities::Check
      end

    end

  end
end

