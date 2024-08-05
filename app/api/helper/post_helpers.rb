module Helper
  module PostHelpers
    def create_new_post(user,caption,body,media)
      post = user.posts.new(caption: caption,
                              body: body)
      if !media.nil? && !post.media.attach(io: media["tempfile"] , filename: media["filename"] )
        err_msg = "Media not able to upload"
        raise Exceptions::PostExceptions::MediaNotAbleToUpload.new([err_msg]) , err_msg
      end
      if post.save
        post.id
      else
        raise  Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
    rescue Seahorse::Client::NetworkingError 
      raise Exceptions::PostExceptions::S3Unavailable.new(["network error"]) , "not able to connect to s3 bucket"
    rescue Exceptions::PostExceptions::InvalidPost , Exceptions::PostExceptions::MediaNotAbleToUpload => e
      error(e.errors,403)
    end

    def get_all_posts(user)
      user.posts.all
    rescue ActiveRecord::RecordNotFound
      user_not_found!
    end

    def edit_post(user,postId,caption,body)
      post = user.posts.find(postId)  
      if post.caption != caption || post.body != body
        post.caption = caption
        post.body = body
        if !post.save 
          raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
        end
      end
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exceptions::PostExceptions::InvalidPost => e
      error(e.errors,403)
    end
    
    #Todo
    def delete_post(user,postId)
      user.posts.destroy(postId)
    rescue
      err_msg = "Unable to delete"
      raise Exception::PostExceptions::InvalidPost.new([err_msg]), err_msg
    end

    def archive_post(user, postId)
      post = user.posts.find(postId)
      post.archived = true
      if !post.save
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exceptions::PostExceptions::InvalidPost => e
      error(e.errors,403)
    end

    def like_post(user,postId)
      history = user.history.find_by(post_id: postId)
      if history.present?
        err_msg = "post already liked"
        raise Exception::PostExceptions::PostAlreadyLiked.new([ err_msg ]), err_msg
      end
      post = Post.find(postId)
      post.likes += 1
      history = user.history.create(post: post , status: :liked) 
      if !history.save && !post.save
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exception::PostExceptions::PostAlreadyLiked,Exceptions::PostExceptions::InvalidPost => e
      error(e.errors,403)
    end

    def dislike_post(user,postId)
      history = user.history.find_by(post_id: postId)
      if history.present?
        err_msg = "post already liked"
        raise Exception::PostExceptions::PostAlreadyLiked.new([ err_msg ]), err_msg
      end
      post = Post.find(postId)
      post.likes += 1
      history = user.history.create(post: post , status: :disliked) 
      if !history.save && !post.save
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exception::PostExceptions::PostAlreadyLiked,Exceptions::PostExceptions::InvalidPost => e
      error(e.errors,403)
    end

    def handle_action(user,action,postId)
      case action
      when "like"
          like_post @current_user,postId
      when "dislike"
          dislike_post @current_user,postId
      end
    end
    
  end
end
 
