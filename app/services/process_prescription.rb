def process_prescription(params)
  user_id = params[:user_id] # ID do Paciente
  medication_id = params[:medication_id]
  new_quantity = params[:quantity].to_i
  new_time = params[:time]

  # Busca todas as receitas existentes desse medicamento pro paciente
  existing_prescriptions = Prescription.where(user_id: user_id, medication_id: medication_id)

  if existing_prescriptions.empty?
    # Primeira vez que esse remédio tá sendo prescrito
    new_prescription = Prescription.create!(params)
    return { status: :created, message: "#{new_prescription.medication.substance} adicionada com sucesso ao tratamento." }
  end

  # Soma atual de doses por horário
  current_doses = existing_prescriptions.group_by(&:time).transform_values do |prescs|
    prescs.sum { |p| p.quantity.to_i }
  end

  # Dose atual no horário específico (se existir)
  current_quantity_at_time = current_doses[new_time] || 0

  # Diferença entre o que ele já toma e o que a nova receita quer
  difference = new_quantity - current_quantity_at_time

  if difference == 0
    return { status: :ok, message: "Paciente já toma essa dose nesse horário. Nenhuma alteração feita." }
  elsif difference > 0
    # Aumentar dose nesse horário
    Prescription.create!(
      user_id: user_id,
      medication_id: medication_id,
      quantity: difference,
      time: new_time,
      action_type: :add
    )
    return { status: :created, message: "Dose aumentada em #{difference} às #{new_time}" }
  else
    # Reduzir dose nesse horário
    Prescription.create!(
      user_id: user_id,
      medication_id: medication_id,
      quantity: difference, # isso vai ser negativo
      time: new_time,
      action_type: 2 # supondo que 2 = redução
    )
    return { status: :created, message: "Dose reduzida em #{difference.abs} às #{new_time}" }
  end
end

def find_medication
  medication =Medication.find_by(id: medication_id)
  return { status: :unprocessable_entity, message: "Medicação não encontrada." } unless medication
  medication
end
