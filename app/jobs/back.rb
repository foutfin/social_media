class UserMailerJob < ApplicationJob
  queue_as :default

  def perform(user,accepted_by)
    UserMailer.follow_accept(user,accepted_by).deliver_now
  end
end
