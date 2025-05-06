# Service principal para processar prescrições
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
    return error("Medicação não encontrada.") unless @medication
    return error("Paciente não encontrado.") unless @patient
    return error("Médico não encontrado.") unless @physician
    return error("Usuário não autorizado.") unless @current_user.in?([ @physician, @patient ])

    current_treatment = TreatmentAnalyzer.current_treatment_for(@patient, medication: @medication)
    current_qty_at_time = TreatmentAnalyzer.current_treatment_for(@patient, medication: @medication, time: @time).pluck(:quantity)[0]

    result =
      if current_treatment.empty?
        [ :new_medication, "#{@medication.substance} foi adicionado ao tratamento." ]
      else
        action_type(@quantity, current_qty_at_time)
      end

    begin
      Prescription.create!(
        patient: @patient,
        physician: @physician,
        current_user_id: @current_user.id,
        medication: @medication,
        quantity: @quantity,
        time: @time,
        action_type: result[0]
      )
      PhysicianPatientLinker.call(@physician, @patient)
      success(result[1])
    rescue ActiveRecord::RecordInvalid => e
      error("Erro ao salvar a prescrição: #{e.message}")
    end
  end

  def success(message)
    { status: :created, message: message }
  end

  def error(message)
    { status: :unprocessable_entity, message: message }
  end

  private

  def action_type(new_quantity, old_quantity)
    if new_quantity.zero?
      [ :remove_medication, "Dose de #{@medication.substance} às #{@time} foi retirada." ]
    elsif new_quantity < old_quantity
      [ :reduce_dosis, "Dose de #{@medication.substance} às #{@time} foi reduzida de #{old_quantity} para #{new_quantity}." ]
    elsif new_quantity > old_quantity
      [ :increase_dosis, "Dose de #{@medication.substance} às #{@time} foi aumentada de #{old_quantity} para #{new_quantity}." ]
    else
      [ :no_changes, "Essa já é a dose às #{@time}. Nenhuma alteração realizada." ]
    end
  end
end
