module Admin
  # Has user management methods for admin-level users
  class UsersController < ApplicationController
    before_action :authorize!
    before_action :authorize_admin!

    def index
      render_api_success(:listed, data: User.all, status: :ok)
    end

    def show
      user = User.find(params[:id])
      render json: user
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

      return render_api_error(:invalid_parameters, status: :unprocessable_entity) if role.blank?

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
      params.expect(user: %i[name email password role])
            .compact_blank!
    end
  end
end
