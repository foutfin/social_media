class PostCreationMailerJob
  include Sidekiq::Job

  def perform(user_id,post_id)
    user = User.find(user_id)
    sendToAllFollowers(user,post_id)
  end

  private
  def sendToAllFollowers(user,post_id)
    user.followers.each do |follower|
      UserMailer.post_creation(follower_id , post_id ).deliver_now
    end
  end
  

end

