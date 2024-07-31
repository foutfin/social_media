module Helper
  module AuthHelpers
    def authenticate
      decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key, true)
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
    
    def check_connection(postId)
      @post = Post.find(postId)
      if @post.user_id == @current_user.id
        return 
      end
      connection =  Connection.where("(follow_by_id = ? and follow_to_id = ? ) or ( follow_by_id = ? and follow_to_id = ? )", 
                                      @current_user, @post.user , @post.user , @current_user)
      if !(connection.length == 1)
        not_have_connection!
      end

    rescue
      post_not_found!
    end

  end
end
 
