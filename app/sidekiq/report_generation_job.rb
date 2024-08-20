class ReportGenerationJob
  include Sidekiq::Job
  include Helper::SpreadsheetHelpers
  sidekiq_options queue: 'report' , retry_queue: 'retry_queue' , retry: 5
  def perform(user_id)
    user = User.find(user_id)
    report_generation user
    UserMailer.with(user: user , username: user.username).send_report.deliver_now  
  end

end
