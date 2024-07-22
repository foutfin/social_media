module PostHelper
  def getAllPost
    @posts = @current_user.posts.all
  end

  def getShowUserPost
    @show_user_posts = @show_user.posts.all
  end


end
