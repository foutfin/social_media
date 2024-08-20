require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe UnfollowMailerJob, type: :job do
  let (:user_id) { 60}
  let (:to_unfollow_id) { 62}

 it "job should enqueue" do
    expect {
      UnfollowMailerJob.perform_async(user_id, to_unfollow_id)
    }.to change(UnfollowMailerJob.jobs , :size).by(1)
 end

 it "job should enqueue to unfollow queue" do
  queue = nil 
  Sidekiq::Queue.all.each do |q|
    if q.name == "unfollow"
      queue = q
    end
  end
  prev_len = queue.count
  UnfollowMailerJob.perform_async(user_id, to_unfollow_id)
  expect(queue.count).to eq(prev_len+1)
 end

end
