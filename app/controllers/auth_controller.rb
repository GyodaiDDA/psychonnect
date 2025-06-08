# Login methods using JWT gem
class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      data = { token: token, user: user.slice(:id, :name, :email, :role) }
      render_api_success(:login_successful, data: data, status: :ok)
    else
      render_api_error(:invalid_credentials, status: :unauthorized)
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end
end
