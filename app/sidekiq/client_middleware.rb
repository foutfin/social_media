class ClientMiddleware
  def call(job_class, msg, queue, redis_pool)
    queues = ["new_post", "follow" , "unfollow" , "report"]
    if !queues.include?(queue)
      Rails.logger.error "Wrong queue used"
      return false
    end
    Rails.logger.info "Job Class :- #{job_class}, Queue Used :- #{queue} , JobId :- #{msg["jid"]} , with args :- #{msg["args"]}"
    yield
  end
end
