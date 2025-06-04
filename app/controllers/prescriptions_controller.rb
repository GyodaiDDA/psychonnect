# Prescriptions CRUD
class PrescriptionsController < ApplicationController
  before_action :authorize!
  before_action :authorize_admin!, only: %i[destroy]

  def index
    patient = User.find_by(id: params[:patient_id]) if params[:patient_id]
    return render_api_error(:not_found, status: :not_found, item: :patient) unless patient

    medication = Medication.find_by(id: params[:medication_id])

    time = params[:time]

    prescriptions = TreatmentAnalyzer.current_treatment_for(patient, medication:, time:)
    render json: prescriptions
  end

  def history
    patient = User.find_by(id: params[:patient_id])
    return render_api_error(:not_found, status: :not_found, item: :patient) unless patient

    medication = Medication.find_by(id: params[:medication_id])

    time = params[:time]

    prescriptions = TreatmentAnalyzer.history(patient, medication:, time:)
    render json: prescriptions
  end

  def show
    prescription = Prescription.find(params[:id])
    return render_api_error(:not_found, status: :not_found, item: :prescription) unless prescription

    render json: prescription
  end

  def create
    prescription = PrescriptionProcessor.call(prescription_params, current_user)
    render json: { message: prescription[:message] }, status: prescription[:status]
  end

  def update
    prescription = Prescription.find(params[:id])
    return render_api_error(:not_found, status: :not_found, item: :prescription) unless prescription

    if prescription.update(prescription_params)
      render json: prescription
    else
      render_api_error(:invalid_parameters, errors: prescription.errors.full_messages, status: :unprocessable_entity)
    end
  end

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
