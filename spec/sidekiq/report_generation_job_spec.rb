require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe ReportGenerationJob, type: :job do
  let (:user_id) { 60}

 it "job should enqueue" do
    expect {
      ReportGenerationJob.perform_async user_id
    }.to change(ReportGenerationJob.jobs , :size).by(1)
 end

 it "job should enqueue to report queue" do
  options = ReportGenerationJob.sidekiq_options 
  expect(options["queue"]).to eq("report")
 end

 it "valid if report saved to s3" do
  user = User.find(user_id)
  ReportGenerationJob.perform_async user_id
  byebug
  expect(user.report.attached?).to eq(true)
 end

end
