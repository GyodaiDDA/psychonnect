# Service principal para processar prescrições
class PrescriptionProcessor
  def self.call(params, current_user)
    new(params, current_user).process
  end

  def initialize(params, current_user)
    @params = params
    @physician_id = params[:physician_id]  # médico
    @patient_id = params[:patient_id]  # paciente
    @current_user = current_user
    @medication_id = params[:medication_id]
    @quantity = params[:quantity].to_i
    @time = params[:time]
  end

  def process
    # Confere se a medicação existe
    medication = Medication.find_by(id: @medication_id)
    return error("Medicação não encontrada.") unless medication

    # Confere o paciente
    patient = User.find_by(id: @patient_id)
    return error("Paciente não encontrado.") unless patient

    # Confere o médico
    physician = User.find_by(id: @physician_id)
    return error("Médico não encontrado.") unless physician

    # Confere quem é o usuário atual
    return error("Usuário não autorizado.") unless current_user.in?([ physician, patient ])

    # Busca pela medicação no tratamento do paciente
    existing_prescriptions = Prescription.where(patient: patient, medication: medication)

    if existing_prescriptions.empty?
      # Primeira receita dessa medicação
      presc = Prescription.create!(
        patient: patient,
        physician: physician,
        current_user: @current_user,
        medication: medication,
        quantity: @quantity,
        time: @time,
        action_type: 0
      )
      return success("#{medication.substance} foi adicionado ao tratamento.")
    end

    # Soma atual por horário
    current_doses = existing_prescriptions.group_by(&:time).transform_values do |prescs|
      prescs.sum { |p| p.quantity.to_i }
    end

    current_quantity_at_time = current_doses[@time] || 0
    difference = @quantity - current_quantity_at_time

    if @quantity.zero?
      success("Dose de #{medication.substance} às #{@time} foi retirada")
      presc = Prescription.create!(
        patient: patient,
        physician: physician,
        current_user: @current_user,
        medication: medication,
        quantity: @quantity,
        time: @time,
        action_type: 10
      )
    elsif difference == 0
      success("#{medication.substance}: paciente já toma essa dose às #{@time}. Nenhuma alteração feita.")
    elsif difference > 0
      presc = Prescription.create!(
        patient: patient,
        physician: physician,
        current_user: @current_user,
        medication: medication,
        quantity: @quantity,
        time: @time,
        action_type: 1
      )
      success("Dose de #{medication.substance} às #{@time} foi aumentada de #{current_quantity_at_time} para #{@quantity} ")
    else
      presc = Prescription.create!(
        patient: patient,
        physician: physician,
        current_user: @current_user,
        medication: medication,
        quantity: @quantity,
        time: @time,
        action_type: 2
      )
      success("Dose de #{medication.substance} às #{@time} foi reduzida de #{current_quantity_at_time} para #{@quantity} ")
    end
  end

  private

  def success(message)
    { status: :created, message: message }
  end

  def error(message)
    { status: :unprocessable_entity, message: message }
  end
end
