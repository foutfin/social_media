class UserMailer < ApplicationMailer
  def follow_accept(user_id,accepted_by_id)
    @user = User.find(user_id)
    @accepted_by = User.find(accepted_by_id)
    mail(to: @user.email , subject: "Follow request accepted by #{@accepted_by.username}" )
  end

  def unfollow(user_id ,to_unfollow_id)
    @user = User.find(user_id)
    @to_unfollow_user= User.find(to_unfollow_id)
    mail(to: @to_unfollow_user.email , subject: "#{@user.username} unfollowed you" )
  end

  def post_creation(to_send_id , from_id ,post_id)
    @user_to_send = User.find(to_send_id)
    @user = User.find(from_id)
    @post = Post.find(post_id)
    mail(to: @user_to_send.email , subject: "New Post Update")
  end

  def send_report
    @user = params[:user]
    attachments["report.xls"] = @user.report_attachment.download
    mail(to:@user.email  , subject: "Report")
  end

end
