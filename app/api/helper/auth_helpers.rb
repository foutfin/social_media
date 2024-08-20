module Helper
  module AuthHelpers
    def authenticate
      decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key, true)
      jti = decoded_token[0]["jti"]
      # user = User.find_by(jti: decoded_token[0]["jti"])
      user = get_user_cache jti
      if user.nil? 
        unauthorized_error! 
      else
        @current_user ||= user
      end
    rescue
      unauthorized_error! 
    end

    def logout 
      invalidate_cache @current_user.jti
      uuid = SecureRandom.uuid
      @current_user.jti = uuid 
      if !@current_user.save
        unauthorized_error! 
      end     
    end

    def token
      auth = headers['Authorization'].to_s
      token_split = auth.split
      if token_split.first != "Bearer" || token_split.length != 2
        unauthorized_error! 
      end
      token_split.last
    end
    
    def check_connection(postId)
      if postId.nil?
        error(["postId is missing"],400)
        return
      end
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
