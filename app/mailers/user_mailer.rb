class UserMailer < ApplicationMailer
  def follow_accept(user_id,accepted_by_id)
    @user = User.find(user_id)
    @accepted_by = User.find(accepted_by_id)
    mail(to: @user.email , subject: "Follow request accepted by #{@accepted_by.username}" )
  end

  def post_creation(user_id , post_id)
    @user = User.find(user_id)
    @post = @user.posts.find(post_id)
    mail(to: @user.email , subject: "New Post Update")
  end

  def test
    mail(to: "navinpatelkumar12@gmail.com" , subject: "test" , body: "body" )
  end
  
 


end
