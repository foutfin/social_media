module V1
  class UserRegistrationApi < Grape::API
    namespace :user do
      namespace :register do
        params do 
          requires :first_name , type: String
          requires :last_name , type: String
          requires :email , type: String , regexp: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
          requires :username , type: String 
          requires :password , type: String
          optional :bio , type: String
        end

        post do
          @new_user = UserRegistrationService.new(params[:first_name],params[:last_name],params[:email],params[:username],params[:bio],params[:password])
          begin
            @new_user.register
            { :status => 200 , :msg => "User Created Successfully"}
          rescue 
            { :err => @new_user.errors }
          end
        end

      end

    end
  end
end
