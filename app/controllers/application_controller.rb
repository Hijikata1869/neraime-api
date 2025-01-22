class ApplicationController < ActionController::API
  def create_token(user_id)
    payload = {exp: 24.hours.from_now.to_i, user_id: user_id}
    secret_key = Rails.application.credentials.secret_key_base
    token = JWT.encode(payload, secret_key, 'HS256')
    return token
  end

  def fetch_current_user
    token = request.headers['Authorization']
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      current_user = User.find(decoded_token[0]['user_id'])
      if current_user
        return current_user
      end
  end

  def authenticate_user
    token = request.headers['Authorization']
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      current_user = User.find(decoded_token[0]['user_id'])
      current_user && true
    rescue
      render json: {}, status: 401
    end
  end

  def logged_in?
    token = request.headers['Authorization']
    return false unless token
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      current_user = User.find(decoded_token[0]['user_id'])
      return current_user.present?
    rescue
      false
    end
  end

end
