class MedicationsController < ApplicationController
  def index
    render json: Medication:all
  end

  def show
    medication = Medication.find(params[:id])
    render json: medication
  end

  def create
    medication = Medication.new(medication_params)
    if medication.save
      render json: medication, status: :created
    else
      render json: medication.errors, status: :unprocessable_entity
    end
  end

  def update
    medication = Medication.find(params[:id])
    if medication.update(medication_params)
      render json: medication
    else
      render json: medication.errors, status: :unprocessable_entity
    end
  end

  def destroy
    medication = Medication.find(params[:id])
    medication.destroy
    head :no_content
  end

  private

  def medication_params
    params.require(:medication).permit(:substance, :dosage, :unit)
  end
end
