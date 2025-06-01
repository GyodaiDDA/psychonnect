# Methods of authentication for general use in controllers
class ApplicationController < ActionController::API
  include ApiResponse

  def current_user
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last

    return nil unless token

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')[0]
      User.find(decoded['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  def authorize!
    return if current_user

    render_api_error(:unauthorized, status: :unauthorized)
  end

  def authorize_admin!
    return if current_user&.admin?

    render_api_error(:forbidden, status: :forbidden)
  end

  rescue_from ActiveRecord::RecordNotFound do |_e|
    render_api_error(:not_found, status: :not_found)
  end
end
