module Helper
  module UserHelpers
    def get_user_by_username(username)
      User.find_by(username: username)
    rescue
      err_msg = "user not found"
      raise Exception::UserExceptions::UserNotFound.new([err_msg]),err_msg
    end

    def about_me(user)
      user
    end

    def edit_user(user,first_name,last_name,bio)
      if user.first_name == first_name && user.last_name == last_name && user.bio == bio
        return
      end
      user.first_name = first_name
      user.last_name = last_name
      user.bio = bio

      if !user.save 
        raise Exception::PostExceptions::InvalidUser.new(user.errors.full_messages), "invalid user"
      end
    end
    
    def generate_follow_request(user,otherUserId)
      to_follow_user = User.find(otherUserId)
      follow_request = FollowRequest.new(from: user , to: to_follow_user)
      if follow_request.save 
        follow_request.id
      else
        raise Exception::UserExceptions::InvalidFollowRequest.new(follow_request.errors.full_messages),"invalid follow request"
      end
    rescue
      err_msg = "User Not Found"
      raise Exception::UserExceptions::UserNotFound.new([err_msg]),err_msg
    end

    def unfollow_user(user,otherUserId)
      to_unfollow_user = User.find(otherUserId)
      connection = Connection.find_by(follow_by: user , follow_to: to_unfollow_user)
      if !connection.present?
        err_msg = "User Connection not found"
        raise Exception::UserExceptions::ConnectionNotFound.new([err_msg]), err_msg
      end
      connection.destroy
    rescue 
      err_msg = "User Not Found"
      raise Exception::UserExceptions::UserNotFound.new([err_msg]),err_msg
    end

  end
end
