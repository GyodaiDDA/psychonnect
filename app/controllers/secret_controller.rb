# app/controllers/secret_controller.rb
class SecretController < ApplicationController
  before_action :authorize_user!

  def index
    render json: {
      message: 'Parabéns, você está autenticado!',
      user: current_user.slice(:id, :name, :email, :role)
    }
  end
end
