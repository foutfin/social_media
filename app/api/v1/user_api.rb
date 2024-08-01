module V1
  class UserApi < Grape::API
    helpers Helper::UserHelpers
    helpers Helper::AuthHelpers

    namespace :user do
      before do
          authenticate
      end

      get :me do
        about_me @current_user
      end

      params do
        optional :status , type: String , values: ["pending" , "rejected" , "approved"]
      end
      get "/followrequests" do
        follow_requests = get_all_follow_requests @current_user , params[:status] 
        { :status => 200 , :msg=> "ok" , :res => follow_requests }
      end

      get "/:username" do
        user = get_user_by_username params[:username]
        begin
          { :status => 200 , :res => user }
        rescue => e
          { :status => 403 , :err => e.errors} 
        end
      end

      params do
        optional :first_name , type: String
        optional :last_name , type: String
        optional :bio , type: String
        at_least_one_of :first_name , :last_name , :bio
      end
      put do
        edit_user @current_user,params[:first_name],params[:last_name], params[:bio] 
        { :status => 200 , :msg => "ok" }
      end

      params do
        requires :user_id , type: Integer
      end
      post "/follow" do
        begin
          request_id = generate_follow_request @current_user, params[:user_id]
          { :status => 200 , :msg => "ok" , :res => request_id } 
        rescue => e
          pp "Error #{e}"
          { :status => 400 , :err => e.errors}
        end
      end

      params do
        requires :user_id , type: Integer
      end
      post "/unfollow" do
        unfollow_user @current_user, params[:user_id] 
      end
      
      namespace :followrequest do
        params do
          requires :request_id , type: Integer
          requires :user_id , type: Integer
          requires :accept , type: Boolean
        end
        post do 
          if accept 
            accept_follow_request @current_user , params[:request_id] , params[:user_id] 
          else
            reject_follow_request @current_user , params[:request_id] , params[:user_id]
          end
        end

      end

    end
  end
end
