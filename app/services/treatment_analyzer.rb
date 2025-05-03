# Métodos de coleta e compilação de dados do tratamento
class TreatmentAnalyzer
  def self.current_treatment_for(patient, medication: nil, time: nil)
    query = current_treatment.where(patient:) # Tratamento atual completo de um paciente
    query = query.where(medication:) if medication # Horários e quantidades da medicação no tratamento atual
    query = query.where(time:) if time # Quantidade da medicação / ou de todas as medicações se medication: nil num determinado horário
    query
  end
  
  def self.history(patient, medication: nil, time: nil)
    query = full_query.where(patient:) # Histórico de tratamento de um paciente
    query = query.where(medication:) if medication # Histórico de horários e quantidades do remédio para o paciente
    query = query.where(time:) if time # Histórico de quantidade da medicação / ou de todas as medicações se medication: nil num determinado horário
    query
  end

  private

  def self.full_query()
    query = Prescription.select(
      <<~SQL
        *,
        ROW_NUMBER() 
        OVER(
          PARTITION BY patient_id, medication_id, time
          ORDER BY created_at DESC
          )
        AS row_number
      SQL
    )
  end

  def self.current_treatment()
    Prescription.from(full_query, :prescriptions)
                .where("row_number = 1 AND quantity > 0")
  end
end