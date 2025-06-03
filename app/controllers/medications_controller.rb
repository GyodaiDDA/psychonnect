# Medication CRUD
class MedicationsController < ApplicationController
  def index
    render_api_success(:listed, data: Medication.all, status: :ok)
  end

  def show
    medication = Medication.find_by(id: params[:id])
    return render_api_error(:not_found, status: :not_found) unless medication

    render_api_success(:item_found, data: medication)
  end

  def create
    medication = Medication.new(medication_params)
    if medication.save
      render_api_success(:item_created, status: :created)
    else
      render_api_error(:missing_parameters, errors: medication.errors.full_messages, status: :unprocessable_entity)
    end
  end

  def update
    medication = Medication.find(params[:id])
    if medication.update(medication_params)
      render_api_success(:item_updated, status: :ok)
    else
      render_api_error(:unprocessable_entity, errors: medication.errors.full_messages, status: :unprocessable_entity)
    end
  end

  def destroy
    medication = Medication.find(params[:id])
    return render_api_error(:not_found, status: :not_found) unless medication

    medication.destroy
    head :no_content
  end

  private

  def medication_params
    params.expect(medication: %i[substance dosage measure])
  end
end
