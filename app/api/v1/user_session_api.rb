module V1
  class UserSessionApi < Grape::API
    helpers Helper::AuthHelpers
    helpers Helper::CacheHelpers

    namespace :user do
      namespace :login do
        params do 
          requires :username , type: String 
          requires :password , type: String
        end

        after do
          header 'Authorization' , @user.token
        end

        post do
          @user = UserSessionService.new(params[:username],params[:password])
          begin
            @user.login
            { :status => 200 , :msg => "Login Successful"}
          rescue
            error(@user.errors,404)
            
          end
        end
      end
      
      namespace :logout do
        before do
          authenticate
        end

        delete do
          logout
          { :status => 200 , :msg => "Logged out Successful"} 
        end
      end

    end
  end
end
