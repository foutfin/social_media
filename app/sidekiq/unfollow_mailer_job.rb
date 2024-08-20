class UnfollowMailerJob
  include Sidekiq::Job
  sidekiq_options queue: 'unfollow' , retry_queue: 'retry_queue' , retry: 5

  def perform(user_id,to_unfollow_id)
    UserMailer.unfollow(user_id , to_unfollow_id ).deliver_now
  end

end
