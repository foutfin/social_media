Rails.application.reloader.to_prepare do

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add ServerMiddleware
  end

  config.client_middleware do |chain|
    chain.add ClientMiddleware
  end
end

end
