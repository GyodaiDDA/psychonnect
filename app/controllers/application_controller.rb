class ApplicationController < ActionController::API
  def current_user
    auth_header = request.headers["Authorization"]
    token = auth_header&.split(" ")&.last

    return nil unless token

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256")[0]
      User.find(decoded["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  def authorize!
    render json: { 
      error: {
        code: "unauthorized",
        message: "Invalid authentication credentials"
      }
    },status: :unauthorized unless current_user
  end

  def authorize_admin!
    render json: { 
      error: {
        code: "unauthorized",
        message: "Invalid authentication credentials"
      }
    },status: :unauthorized unless current_user&.admin?
  end
end