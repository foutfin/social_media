require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe UserMailerJob, type: :job do
 let (:user_id) { 60}
 let (:post_id) { 61}

 it "job should enqueue" do
    expect {
      PostCreationMailerJob.perform_async(user_id, post_id)
    }.to change(PostCreationMailerJob.jobs , :size).by(1)
 end


end
#Todo
# see  Sidekiq worker 
