class UsersController < ApplicationController
  before_action :authorize_admin!, only: [ :index, :update_role, :destroy ]

  def index
    render json: User.all
  end

  def show
    user = if current_user.admin?
      User.find(params[:id])
    else
      current_user
    end
    render json: user
  end

  def create
    user = User.new(user_params)
    user.role = safe_role(params[:user][:role])

    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update_role
    user = User.find(params[:id])
    role = safe_role(params[:role])

    begin
      if user.update(role:)
        render json: user
      else
        render json: user.errors, status: :unprocessable_entity
      end
    rescue ArgumentError => e
      render json: { error: "Role inválido: #{role}" }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def safe_role(role)
    return role if %w[patient physician].include?(role.to_s) || current_user&.admin?
    nil
  end
end
