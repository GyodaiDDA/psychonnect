# Medication CRUD
class MedicationsController < ApplicationController
  def index
    render_api_success(:listed, data: Medication.all, status: :ok)
  end

  def show
    medication = Medication.find_by(id: params[:id])
    return render_api_error(:not_found, status: :not_found, item: :medication) unless medication

    render_api_success(:item_found, data: medication)
  end

  def create
    medication = Medication.new(medication_params)
    if medication.save
      render_api_success(:item_created, status: :created)
    else
      render_api_error(:invalid_parameters, errors: medication.errors.full_messages, status: :unprocessable_entity)
    end
  end

  private

  def medication_params
    params.expect(medication: %i[substance dosage measure])
  end
end
