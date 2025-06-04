# Users methods for regular level users
class UsersController < ApplicationController
  before_action :authorize!, only: %i[show update]

  def index
    User.where(id: connected_users.presence)
  end

  def show
    user = User.find(params[:id])
    return render_api_error(:not_found, status: :not_found, item: :user) unless user

    if connected_users.include?(user.id) || current_user == user
      render json: user
    else
      render_api_error(:unauthorized, status: :unauthorized)
    end
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

  def connected_users
    return PhysicianPatient.where(physician_id: current_user.id).pluck(:patient_id) if current_user.physician?

    PhysicianPatient.where(patient_id: current_user.id).pluck(:physician_id) if current_user.patient?
  end

  def user_params
    params.expect(user: %i[name email password])
  end

  def safe_role(role)
    return role if %w[patient physician 1 0].include?(role.to_s) || current_user&.admin?

    nil
  end
end
