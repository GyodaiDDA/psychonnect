module Admin
  # Medication management for admin-level users
  class MedicationsController < ApplicationController
    before_action :authorize_admin!

    def update
      medication = Medication.find_by(id: params[:id])
      return render_api_error(:not_found, status: :not_found, item: :medication) unless medication

      if medication.update(medication_params)
        render_api_success(:item_updated, status: :ok)
      else
        render_api_error(:invalid_parameters, errors: medication.errors.full_messages, status: :unprocessable_entity)
      end
    end

    def destroy
      medication = Medication.find_by(id: params[:id])
      return render_api_error(:not_found, status: :not_found, item: :medication) unless medication

      medication.destroy
      head :no_content
    end

    private

    def medication_params
      params.expect(medication: %i[substance dosage measure])
    end
  end
end
