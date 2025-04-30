class PrescriptionsController < ApplicationController
  before_action :authorize!

  def index
    render json: Prescription.all
  end

  def show
    prescription = Prescription.find(params[:id])
    render json: prescription
  end

  def create
    prescription = Prescription.new(prescription_params)
    if prescription.save
      render json: prescription, status: :created
    else
      render json: prescription.errors, status: :unprocessable_entity
    end
  end

  def update
    prescription = Prescription.find(params[:id])
    if prescription.update(prescription_params)
      render json: prescription
    else
      render json: prescription.errors, status: :unprocessable_entity
    end
  end

  def destroy
    prescription = Prescription.find(params[:id])
    prescription.destroy
    head :no_content
  end

  private

  def prescription_params
    params.require(:prescription).permit(:patient_id, :physician_id, :medication_id, :action_type, :quantity, :time)
  end
end
