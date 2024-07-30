module V1
  class UserSessionApi < Grape::API
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
            { :err => @new_user.errors }
          end
        end
      end
      
      namespace :logout do
        before do
          authenticate
        end

        delete do
          uuid = SecureRandom.uuid
          @current_user.jti = uuid 
          if @current_user.save
            { :status => 200 , :msg => "Logged out Successful"}
          else
            unauthorized_error! 
          end
        end
      end

    end
  end
end
