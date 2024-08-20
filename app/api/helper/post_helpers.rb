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
        invalidate_post_filter_cache user.id
        PostCreationMailerJob.perform_async(user.id,post.id)
        post.id
      else
        raise  Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
    rescue Seahorse::Client::NetworkingError 
      error(["unable to upload"],403)
    rescue Exceptions::PostExceptions::InvalidPost , Exceptions::PostExceptions::MediaNotAbleToUpload => e
      error(e.errors,403)
    end

    def get_all_posts(user,pageNo,limit,sortType,type)
      type = "all" if type.nil?
      pageNo = 1 if pageNo.nil? 
      limit = 10 if limit.nil?
      get_cache_filter(user.id , type , pageNo,limit)
      
      case type
      when "all"
        query = "archived = false"
      when "text"
        query = "archived = false AND body IS NOT null AND (body = '') IS NOT TRUE"
      when "media"
        query = "archived = false AND (body IS null OR (body = '') IS  TRUE)"
      when "archive"
        query = "archived = true"
      else
        query = "archived = ?"
      end

      case sortType
      when "date"
        res = user.posts.select("posts.*, COUNT(*) OVER () as total").where(query).offset((pageNo-1)*limit).limit(limit).order(created_at: :desc)
      when "like"
        res = user.posts.select("posts.*, COUNT(*) OVER () as total").where(query).offset((pageNo-1)*limit).limit(limit).order(likes: :desc)
      else
        res = user.posts.select("posts.*, COUNT(*) OVER () as total").where(query).offset((pageNo-1)*limit).limit(limit).order(created_at: :desc)
      end
      if res.length == 0
        return { res: res , 
                  totalPage: 0 ,
                   currentPage: pageNo }
      end
      totalPage = (res.first.try(:total)/limit) + 1
      if pageNo > totalPage
        raise Exceptions::PaginationExceptions::InvalidPageNo.new(["invalid page"]),"invalid page"
      end
      write("#{user.id}-#{type}-#{limit}" , {   "#{pageNo}" => { res: res , totalPage: totalPage , currentPage: pageNo } }   )
      { res: res , totalPage: totalPage , currentPage: pageNo }
    rescue ActiveRecord::RecordNotFound
      user_not_found!
    rescue Exceptions::PaginationExceptions::InvalidPageNo
      invalid_page!
    end

    def edit_post(user,postId,caption,body)
      post = user.posts.find(postId)
      if post.caption == caption && post.body == body 
        return
      end
      post.caption = caption if !caption.nil?
      post.body = body if !body.nil?
      if !post.save 
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
      invalidate_post_filter_cache user.id
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exceptions::PostExceptions::InvalidPost => e
      error(e.errors,403)
    end
    
    def delete_post(user,postId)
      user.posts.destroy(postId)
      invalidate_post_filter_cache user.id
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    end

    def archive_post(user, postId)
      post = user.posts.find(postId)
      post.archived = true
      if !post.save
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
      invalidate_post_filter_cache user.id
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exceptions::PostExceptions::InvalidPost => e
      error(e.errors,403)
    end

    def unarchive_post(user, postId)
      post = user.posts.find(postId)
      post.archived = false
      if !post.save
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
      invalidate_post_filter_cache user.id
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exceptions::PostExceptions::InvalidPost => e
      error(e.errors,403)
    end

    def like_post(user,postId)
      history = user.history.find_by(post_id: postId)
      if history.present?
        err_msg = "post already liked"
        raise Exceptions::PostExceptions::PostAlreadyLiked.new([ err_msg ]), err_msg
      end
      post = Post.find(postId)
      post.likes += 1
      history = user.history.create(post: post , status: :liked) 
      if !history.save 
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
      if !post.save
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exceptions::PostExceptions::PostAlreadyLiked,Exceptions::PostExceptions::InvalidPost => e
      error(e.errors,403)
    end

    def dislike_post(user,postId)
      history = user.history.find_by(post_id: postId)
      if history.present?
        err_msg = "post already liked"
        raise Exceptions::PostExceptions::PostAlreadyLiked.new([ err_msg ]), err_msg
      end
      post = Post.find(postId)
      post.dislikes += 1
      history = user.history.create(post: post , status: :disliked) 
      if !history.save 
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
      if !post.save
        raise Exceptions::PostExceptions::InvalidPost.new(post.errors.full_messages) , "Invalid Post"
      end
    rescue ActiveRecord::RecordNotFound
      post_not_found!
    rescue Exceptions::PostExceptions::PostAlreadyLiked,Exceptions::PostExceptions::InvalidPost => e
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
 
