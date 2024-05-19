Rails.application.config.middleware.use OmniAuth::Builder do
    provider :line, ENV['LINE_LOGIN_CHANNEL_ID'], ENV['LINE_LOGIN_CHANNEL_SECRET']
  end
  