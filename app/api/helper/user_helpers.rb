module Helper
  module UserHelpers

    def get_user_by_username(userId)
      User.find(userId)
    rescue ActiveRecord::RecordNotFound
      user_not_found!
    end

    def about_me(user)
      user
    end

    def edit_user(user,first_name,last_name,bio)
      if user.first_name == first_name && user.last_name == last_name && user.bio == bio
        return
      end
      user.first_name = first_name if !first_name.nil?
      user.last_name = last_name if !last_name.nil?
      user.bio = bio if !bio.nil?
      if !user.save 
        raise Exceptions::UserExceptions::InvalidUser.new(user.errors.full_messages), "invalid user"
      end
    rescue Exceptions::UserExceptions::InvalidUser => e
      error(e.errors,403)
    end
    
    def generate_follow_request(user,otherUserId)
      to_follow_user = User.find(otherUserId)
      follower = user.followers.find_by(follow_by_id: otherUserId)
      if !follower.present? 
        already_friend!
        return
      end
      follow_request = FollowRequest.new(from: user , to: to_follow_user)
      if follow_request.save 
        follow_request.id
      else
        raise Exceptions::UserExceptions::InvalidFollowRequest.new(follow_request.errors.full_messages),"invalid follow request"
      end
    rescue ActiveRecord::RecordNotFound
      user_not_found!
    rescue Exceptions::UserExceptions::InvalidFollowRequest => e
      error(e.errors,403)
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
      user_not_found!
    rescue Exceptions::UserExceptions::ConnectionNotFound
      not_have_connection!
    end
    
    def get_all_follow_requests(user,approved)
      case approved
      when "pending"
        user.follow_requests.pending
      when "rejected"
        user.follow_requests.rejected
      else
        user.follow_requests.pending
      end
    end

    def accept_follow_request(requestId)
      follow_request = FollowRequest.find(requestId)
      if follow_request.approved != false
        connection = Connection.new(follow_by: follow_request.from , follow_to: follow_request.to)
      else
        already_rejected!
      end
      follow_request.destroy
      if !connection.save
        raise Exceptions::UserExceptions::InvalidConnection.new(connection.errors.full_messages), "Invalid connection"
      end
      # if !follow_request.save
      #   raise Exceptions::UserExceptions::InvalidFollowRequest.new(follow_request.errors.full_messages), "Invalid follow request"
      # end
      UserMailerJob.perform_async(follow_request.from_id , follow_request.to_id)
    rescue ActiveRecord::RecordNotFound
      follow_request_not_found!
    rescue Exceptions::UserExceptions::InvalidConnection, Exceptions::UserExceptions::InvalidFollowRequest => e
      error(e.errors,403)
    end

    def reject_follow_request(user , requestId , otherUserId)
      follow_request = FollowRequest.find(requestId)
      follow_request.approved = false
      if !follow_request.save
        raise Exceptions::UserExceptions::InvalidFollowRequest.new(follow_request.errors.full_messages), "Invalid follow request"
      end
    rescue ActiveRecord::RecordNotFound
      user_not_found!
    rescue Exceptions::UserExceptions::InvalidFollowRequest => e
      error(e.errors,403)
    end

    def get_all_followers(user)
      user.followers
    end

    def get_all_following(user)
      user.following
    end

  end
end
