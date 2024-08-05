module V1
  class UserApi < Grape::API
    helpers Helper::UserHelpers
    helpers Helper::AuthHelpers

    namespace :user do
      before do
          authenticate
      end

      get :me do
        me = about_me @current_user
        generate_response(me,Entities::User)
      end

      params do
        optional :status , type: String , values: ["pending" , "rejected" ]
      end
      get "/followrequests" do
        follow_requests = get_all_follow_requests @current_user , params[:status] 
        { :status => 200  , :res => follow_requests }
      end

      get :followers do
        followers = get_all_followers @current_user
        { :status => 200  , :res => followers }
      end

      get :following do
        following = get_all_following @current_user
        { :status => 200  , :res => following }
      end

      get "/:userId" do
        user = get_user_by_username params[:userId]
        generate_response(user,Entities::UnauthenticatedUser)
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
        request_id = generate_follow_request @current_user, params[:user_id]
        { :status => 200  , :res => { :request_id => request_id } } 
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
          requires :accept , type: Boolean
        end
        post do 
          if params[:accept] 
            accept_follow_request  params[:request_id] 
            { :status => 200 , :msg => "ok" }
          else
            reject_follow_request params[:request_id] 
            { :status => 200 , :msg => "ok" }
          end
        end

      end

    end
  end
end
