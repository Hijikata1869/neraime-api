class ApplicationController < ActionController::API
  def create_token(user_id)
    payload = {exp: 24.hours.from_now.to_i, user_id: user_id}
    secret_key = Rails.application.credentials.secret_key_base
    token = JWT.encode(payload, secret_key, 'HS256')
    return token
  end
end
