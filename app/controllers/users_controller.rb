# Users methods for regular level users
class UsersController < ApplicationController
  before_action :authorize!, only: %i[show update]

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
    user = current_user

    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: %i[name email password])
  end

  def safe_role(role)
    return role if %w[patient physician 1 0].include?(role.to_s) || current_user&.admin?

    nil
  end
end
