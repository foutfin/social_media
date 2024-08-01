module Helper
  module UserHelpers

    def get_user_by_username(username)
      User.find_by(username: username)
    rescue
      err_msg = "user not found"
      raise Exceptions::UserExceptions::UserNotFound.new([err_msg]),err_msg
    end

    def about_me(user)
      user
    end

    def edit_user(user,first_name,last_name,bio)
      if user.first_name == first_name && user.last_name == last_name && user.bio == bio
        return
      end
      if !first_name.nil? 
        user.first_name = first_name
      end

      if !last_name.nil?
        user.last_name = last_name
      end

      if !bio.nil?
        user.bio = bio
      end

      if !user.save 
        raise Exceptions::UserExceptions::InvalidUser.new(user.errors.full_messages), "invalid user"
      end
    end
    
    def generate_follow_request(user,otherUserId)
      pp "other userId got #{otherUserId} #{otherUserId.class}"
      to_follow_user = User.find(otherUserId)
      follow_request = FollowRequest.new(from: user , to: to_follow_user)
      if follow_request.save 
        follow_request.id
      else
        raise Exceptions::UserExceptions::InvalidFollowRequest.new(follow_request.errors.full_messages),"invalid follow request"
      end
    rescue ActiveRecord::RecordNotFound
      err_msg = "User Not Found"
      raise Exceptions::UserExceptions::UserNotFound.new([err_msg]),err_msg
    end

    def unfollow_user(user,otherUserId)
      to_unfollow_user = User.find(otherUserId)
      connection = Connection.find_by(follow_by: user , follow_to: to_unfollow_user)
      if !connection.present?
        err_msg = "User Connection not found"
        raise Exceptions::UserExceptions::ConnectionNotFound.new([err_msg]), err_msg
      end
      connection.destroy
    rescue ActiveRecord::RecordNotFound
      err_msg = "User Not Found"
      raise Exceptions::UserExceptions::UserNotFound.new([err_msg]),err_msg
    end
    
    def get_all_follow_requests(user,approved)
      case approved
      when "pending"
        user.follow_requests.pending
      when "approved"
        user.follow_requests.approved
      when "rejected"
        user.follow_requests.rejected
      else
        user.follow_requests.pending
      end
    end

    def accept_follow_request(user , requestId , otherUserId)
      follow_request = FollowRequest.find(requestId)
      connection = Connection.new(follow_by: user , follow_to_id: otherUserId)
      follow_request.approved = true
      if !connection.save
        raise Exceptions::UserException::InvalidConnection.new(connection.errors.full_messages), "Invalid connection"
      end
      if !follow_request.save
        raise Exceptions::UserException::InvalidFollowRequest.new(follow_request.errors.full_messages), "Invalid follow request"
      end
    rescue ActiveRecord::RecordNotFound
      err_msg = "follow request not found"
      raise Exceptions::UserExceptions::FollowRequestNotFound.new([err_msg]) , err_msg
    end

    def reject_follow_request(user , requestId , otherUserId)
      follow_request = FollowRequest.find(requestId)
      follow_request.approved = false
      if !follow_request.save
        raise Exceptions::UserException::InvalidFollowRequest.new(follow_request.errors.full_messages), "Invalid follow request"
      end
    rescue ActiveRecord::RecordNotFound
      err_msg = "follow request not found"
      raise Exceptions::UserExceptions::FollowRequestNotFound.new([err_msg]) , err_msg
    end

  end
end
