class Api < Grape::API
  format :json
  helpers AuthHelpers
  helpers do 
    def unauthorized_error! 
      error!('Unauthorized',401)
    end
  end

  mount V1::UserRegistrationApi
  mount V1::UserSessionApi

  get :me do
    authenticate
    {:msg => @current_user.username}
  end
end
