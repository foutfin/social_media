module V1
  class SearchApi < Grape::API
    helpers Helper::SearchHelpers
    helpers Helper::AuthHelpers
    
    namespace :search do
      rescue_from :all  do |e|
        { :status => 400 , :err => e.errors }
      end
      
      start_time = nil
      before do
        start_time = Time.current
        authenticate
      end
      

      params do
        requires :query, type: String
        optional :page , type: Integer
      end
      get do
        # start_time = Time.current
        pp "Start time #{start_time}"
        search_result = search_users params[:query] , params[:page]
        end_time = Time.current
        pp "Time taken to process #{end_time - start_time} sec"
        { :status => 200,
          :msg => "ok",
          :res => search_result
        }
      end

    end

  end
end

