class UsersMailer < ActionMailer::Base

  def follow_email(user_id)
    @user = User.find(user_id)

    mail(   :to      => @user.email,
            :subject => "follow by"
    ) do |format|
      format.text
      format.html
    end
  end
end
