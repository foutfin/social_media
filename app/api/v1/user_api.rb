module V1
  class UserApi < Grape::API
    helpers Helper::UserHelpers
    helpers Helper::AuthHelpers

    namespace :user do
      before do
          authenticate!
      end

      get "/:username" do
        user = get_user_by_username params[:username]
        begin
          { :status => 200 , :res => user }
        rescue => e
          { :status => 403 , :err => e.errors} 
        end
      end

      get :me do
        about_me 
      end
        
      params do
        requires :first_name , type: String
        requires :last_name , type: String
        requires :bio , type: String
      end
      put do
        edit_user @current_user,first_name,last_name,bio 
      end

      params do
        requires :user_id , type: Integer
      end
      post "/follow" do
        generate_follow_request @current_user, params[:user_id] 
      end

      params do
        requires :user_id , type: Integer
      end
      post "/unfollow" do
        unfollow_user @current_user, params[:user_id] 
      end


    end
    
    

  end
end
