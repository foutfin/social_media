class TestJob
  include Sidekiq::Job
  sidekiq_options queue: 'follow'
  def perform(p)
    pp "Working "
  end

end
