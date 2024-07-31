class Api < Grape::API
  format :json
  helpers Helper::AuthHelpers
  helpers Helper::ErrorHelpers 

  mount V1::UserRegistrationApi
  mount V1::UserSessionApi
  mount V1::PostApi
  mount V1::UserApi

  get :me do
    authenticate
    {:msg => @current_user.username}
  end
end
