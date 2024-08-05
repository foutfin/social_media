class UserMailerJob
  include Sidekiq::Job

  def perform(user_id,accepted_by_id)
    UserMailer.follow_accept(user_id,accepted_by_id).deliver_now
  end

end