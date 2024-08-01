class FollowJob
  include Sidekiq::Job

  def perform(userId)
    mail = UsersMailer.follow_mail(userId)
    mail.delivery_now
  end
  
end
