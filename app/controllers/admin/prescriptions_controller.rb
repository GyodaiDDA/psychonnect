module Admin
  # Prescription management for admin-level users
  class PrescriptionsController < ApplicationController
    before_action :authorize_admin!

    def destroy
      prescription = Prescription.find(params[:id])
      return render_api_error(:not_found, status: :not_found, item: :prescription) unless prescription

      prescription.destroy
      head :no_content
    end

    private

    def prescription_params
      params.expect(prescription: %i[patient_id physician_id medication_id action_type quantity time])
    end
  end
end
