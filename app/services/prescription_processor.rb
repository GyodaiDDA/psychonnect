# Process a create prescription request checking all
# its connections and validations and handling errors
class PrescriptionProcessor
  def self.call(params, current_user)
    new(params, current_user).process
  end

  def initialize(params, current_user)
    @physician = User.find_by(id: params[:physician_id])
    @patient = User.find_by(id: params[:patient_id])
    @current_user = current_user
    @medication = Medication.find_by(id: params[:medication_id])
    @quantity = params[:quantity]
    @time = params[:time]
  end

  def process
    variables_check?
    authorized_user?
    process_prescription
  end

  private

  def process_prescription
    result = determine_prescription_action
    create_prescription(result)
    link_physician_patient
    success(result[1])
  end

  def determine_prescription_action
    current_treatment = TreatmentAnalyzer.current_treatment_for(@patient, medication: @medication, time: @time)

    if current_treatment.empty?
      [:new_medication, I18n.t('api.success.item_created')]
    else
      current_qty_at_time = TreatmentAnalyzer.current_treatment_for(
        @patient, medication: @medication, time: @time
      ).pluck(:quantity)[0]
      action_type(@quantity, current_qty_at_time)
    end
  end

  def create_prescription(result)
    Prescription.create!(
      patient: @patient,
      physician: @physician,
      current_user_id: @current_user.id,
      medication: @medication,
      quantity: @quantity,
      time: @time,
      action_type: result[0]
    )
  end

  def link_physician_patient
    PhysicianPatientLinker.call(@physician, @patient)
  end

  def variables_check?
    missing = {
      physician: @physician,
      patient: @patient,
      medication: @medication
    }.select { |_k, v| v.nil? }.keys

    return false if missing.empty?

    raise ArgumentError, I18n.t('api.error.not_found', item: missing.join(', '))
  end

  def validation_error_message
    return error(I18n.t('api.error.not_found', item: 'medication')) unless @medication
    return error(I18n.t('api.error.not_found', item: 'patient')) unless @patient
    return error(I18n.t('api.error.not_found', item: 'physician')) unless @physician

    nil
  end

  def authorized_user?
    return true if @current_user.in?([@physician, @patient])

    error(I18n.t('api.error.unauthorized'))
  end

  def action_type(new_quantity, old_quantity)
    action = determine_action(new_quantity, old_quantity)
    message = I18n.t("api.success.#{action}",
                     substance: @medication.substance,
                     time: @time,
                     old: old_quantity.to_f || 0,
                     new: new_quantity.to_f)

    [action, message]
  end

  def determine_action(new_quantity, old_quantity)
    return 'remove_medication' if new_quantity.zero?
    return 'reduce_dosis' if new_quantity < old_quantity
    return 'increase_dosis' if new_quantity > old_quantity

    'no_changes'
  end

  def success(message)
    { status: :created, message: message }
  end

  def error(message)
    { status: :unprocessable_entity, message: message }
  end
end
