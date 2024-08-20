class ServerMiddleware
  def call(worker,job , queue)
    queues = ["new_post", "follow" , "unfollow" , "report"]
    if !queues.include?(queue)
      Rails.logger.error "Wrong queue used"
      return false
    end
    # Rails.logger.info "Job Class :- #{job}, Queue Used :- #{queue} , JobId :- #{msg["jid"]} , with args :- #{msg["args"]}"
    yield
  end
end
