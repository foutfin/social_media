require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe UserMailerJob, type: :job do
  let (:user_id) { 60}
  let (:to_follow_id) { 61}

 it "job should enqueue" do
    expect {
      UnfollowMailerJob.perform_async(user_id, to_follow_id)
    }.to change(UnfollowMailerJob.jobs , :size).by(1)
 end

end
