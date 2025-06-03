# Prescriptions CRUD
class PrescriptionsController < ApplicationController
  before_action :authorize!

  def index
    patient = User.find_by(id: params[:patient_id])
    return render json: { error: 'Paciente não encontrado' }, status: :not_found unless patient

    medication = Medication.find_by(id: params[:medication_id])
    time = params[:time]

    prescriptions = TreatmentAnalyzer.current_treatment_for(patient, medication:, time:)
    render json: prescriptions
  end

  def history
    patient = User.find_by(id: params[:patient_id])
    return render json: { error: 'Paciente não encontrado' }, status: :not_found unless patient

    medication = Medication.find_by(id: params[:medication_id])
    time = params[:time]

    prescriptions = TreatmentAnalyzer.history(patient, medication:, time:)
    render json: prescriptions
  end

  def show
    prescription = Prescription.find(params[:id])
    render json: prescription
  end

  def create
    prescription = PrescriptionProcessor.call(prescription_params, current_user)
    render json: { message: prescription[:message] }, status: prescription[:status]
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
    params.expect(prescription: %i[patient_id physician_id medication_id action_type quantity time])
  end
end
