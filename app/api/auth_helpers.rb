module AuthHelpers
  def authenticate
    decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key, true)
    pp "decoded token #{decoded_token}"
    user = User.find_by(jti: decoded_token[0]["jti"])
    if user.present?  
      @current_user ||= user
    else
      unauthorized_error! 
    end
  rescue
   unauthorized_error! 
  end

  def token
    auth = headers['Authorization'].to_s
    pp "auth header got #{auth}"
    auth.split.last
  end

end
 
