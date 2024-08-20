module Helper
  module UserHelpers

    def get_user_by_username(user,otheruserId)
      otheruserId = otheruserId.to_i
      { res: User.find(otheruserId) , isFriend: is_friend(user.id , otheruserId) }
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
      if( !first_name.nil? && !first_name.empty?)
        user.first_name = first_name
      end
      if( !last_name.nil? && !last_name.empty?)
        user.last_name = last_name
      end
      # user.first_name = first_name if !first_name.nil? || first_name.empty?
      # user.last_name = last_name if !last_name.nil? || last_name.empty?
      user.bio = bio if !bio.nil? 
      if user.save 
        invalidate_cache user.jti
      else
        raise Exceptions::UserExceptions::InvalidUser.new(user.errors.full_messages), "invalid user"
      end
    rescue Exceptions::UserExceptions::InvalidUser => e
      error(e.errors,403)
    end

    def home_feed(user,pageNo,limit)
      pageNo = 1 if pageNo.nil? 
      limit = 10 if limit.nil?
      if pageNo <= 0
        err_msg = "Invalid page no"
        raise Exceptions::PaginationExceptions::InvalidPageNo.new([err_msg]), err_msg
      end
      res = user.followed_posts.select("posts.*, COUNT(*) OVER () as total").where("archived = false").offset((pageNo-1)*limit).limit(limit).order(created_at: :desc)
      if res.length == 0
        return { res: res , 
                  totalPage: 0 ,
                   currentPage: pageNo }
      end
      totalPage = (res.first.try(:total)/limit) + 1
      if pageNo > totalPage
        raise Exceptions::PaginationExceptions::InvalidPageNo.new(["invalid page"]),"invalid page"
      end
      { res: res , totalPage: totalPage , currentPage: pageNo }
    rescue Exceptions::PaginationExceptions::InvalidPageNo => e
      error(e.errors,403)
    end
    
    def generate_follow_request(user,otherUserId)
      to_follow_user = User.find(otherUserId)
      follower = user.followers.find_by(follow_by_id: otherUserId)
      if follower.present? 
        already_friend!
        return
      end
      # (?:FAST FORWARD LOGISTICS INDIA PVT ?\.? LTD|NAVIO SHIPPING PRIVATE LIMITED)
      fr = FollowRequest.find_by(from: user , to: to_follow_user)
      if(fr.present?)
        if fr.approved == false
          raise Exceptions::UserExceptions::RejectedFollowRequest.new(["follow request rejected"]),"follow request rejected"
        end
        raise Exceptions::UserExceptions::AlreadySentRequest.new(["follow request already sent"]),"follow request already sent"
      end
      follow_request = FollowRequest.new(from: user , to: to_follow_user)
      if follow_request.save 
        invalidate_followrequest_cache otherUserId
        follow_request.id
      else
        raise Exceptions::UserExceptions::InvalidFollowRequest.new(follow_request.errors.full_messages),"invalid follow request"
      end
    rescue ActiveRecord::RecordNotFound
      user_not_found!
    rescue Exceptions::UserExceptions::InvalidFollowRequest,Exceptions::UserExceptions::RejectedFollowRequest,Exceptions::UserExceptions::AlreadySentRequest => e
      error(e.errors,403)
    end

    def unfollow_user(user,otherUserId)
      to_unfollow_user = User.find(otherUserId)
      pp "#{user.id} #{otherUserId}"
      connection = Connection.find_by(follow_by: user , follow_to: to_unfollow_user)
      if !connection.present?
        err_msg = "User Connection not found"
        raise Exceptions::UserExceptions::ConnectionNotFound.new([err_msg]), err_msg
      end
      connection.destroy
      UnfollowMailerJob.perform_async(user.id , to_unfollow_user.id)
    rescue ActiveRecord::RecordNotFound
      user_not_found!
    rescue Exceptions::UserExceptions::ConnectionNotFound
      not_have_connection!
    end
    
    def get_all_follow_requests(user,approved)
      res = get_cache("#{user.id}-#{approved}")
      if(!res.nil?)
        return  res
      end
      case approved
      when "pending"
        res = user.follow_requests.pending
      when "rejected"
        res = user.follow_requests.rejected
      else
        res = user.follow_requests.pending
      end
      write("#{user.id}-#{approved}" ,  res)
      res
    end

    def accept_follow_request(user,requestId)
      follow_request = FollowRequest.find(requestId)
      if follow_request.to_id != user.id 
        bad_request!
        return
      end
      if follow_request.approved != false
        connection = Connection.new(follow_by: follow_request.from , follow_to: follow_request.to)
      else
        already_rejected!
        return
      end
      follow_request.destroy
      if !connection.save
        raise Exceptions::UserExceptions::InvalidConnection.new(connection.errors.full_messages), "Invalid connection"
      end
      # invalidate_followrequest_cache @user.id
      UserMailerJob.perform_async(follow_request.from_id , follow_request.to_id)
    rescue ActiveRecord::RecordNotFound
      follow_request_not_found!
    rescue Exceptions::UserExceptions::InvalidConnection, Exceptions::UserExceptions::InvalidFollowRequest => e
      error(e.errors,403)
    end

    def reject_follow_request(user , requestId )
      follow_request = FollowRequest.find(requestId)

      if follow_request.to_id != user.id
        bad_request!
        return
      end
      if follow_request.approved == false
        already_rejected!
        return
      end

      follow_request.approved = false
      if !follow_request.save
        raise Exceptions::UserExceptions::InvalidFollowRequest.new(follow_request.errors.full_messages), "Invalid follow request"
      end
      # invalidate_followrequest_cache @user.id
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

    def delete_user(user)
      FollowRequest.where("from_id = ?", user.id).each do |r|
        r.destroy
      end
      invalidate_cache user.jti
      user.destroy
    end

    def is_friend(user_id , other_id)
      if user_id == other_id 
        return true
      end
      connection =  Connection.where("(follow_by_id = ? and follow_to_id = ? ) or ( follow_by_id = ? and follow_to_id = ? )", 
                      user_id, other_id , other_id , user_id)
      if connection.length == 1 
        true
      else
        false
      end
    end

  end
end
