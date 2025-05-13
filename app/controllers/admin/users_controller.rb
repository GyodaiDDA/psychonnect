module Admin
  class UsersController < ApplicationController
    before_action :authorize!
    before_action :authorize_admin!

    def index
      render_api_success(:listed, data: User.all, status: :ok)
    end

    def create
      user = User.new(user_params)

      if user.save
        render_api_success(:listed, data: user, status: :ok)
      else
        render_api_error(:unprocessable_entity, status: :unprocessable_entity)
      end
    end

    def update
      user = User.find(params[:id])
      role = params[:user]&.[](:role)

      unless role.present? && !User.roles.key?(role.to_s)
        return render_api_error(:invalid_parameter, status: :invalid_parameter)
      end

      if user.update(user_params)
        render json: user
      else
        render_api_error(:unprocessable_entity, status: :unprocessable_entity)
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      head :no_content
    end

    private

    def user_params
      params.require(:user)
            .permit(:name, :email, :password, :role)
            .delete_if { |_k, v| v.blank? }
    end
  end
end
