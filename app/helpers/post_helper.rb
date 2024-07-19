module PostHelper
  def getAllPost
    @posts = @current_user.posts.all
  end
end
