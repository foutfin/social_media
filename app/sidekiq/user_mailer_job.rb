class UserMailerJob
  include Sidekiq::Job
  sidekiq_options queue: 'follow' , retry_queue: 'retry_queue' , retry: 5

  def perform(user_id,accepted_by_id)
    UserMailer.follow_accept(user_id,accepted_by_id).deliver_now
  end

end
