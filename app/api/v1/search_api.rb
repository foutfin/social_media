module V1
  class SearchApi < Grape::API
    helpers Helper::SearchHelpers
    helpers Helper::AuthHelpers
    
    namespace :search do
      
      before do
        authenticate
      end
      
      params do
        requires :query, type: String
        optional :limit , type: Integer
        optional :page , type: Integer
      end
      get do
        search_result = []
        benchmark do ||
          search_result = search_users params[:query] , params[:page] , params[:limit]
        end
        outputGenerate search_result , Entities::Check
      end

    end

  end
end

