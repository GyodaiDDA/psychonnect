class TreatmentAnalyzer
  def self.current_treatment_for(patient)
    patient.prescriptions
      .includes(:medication)
      .group_by(&:medication)
      .transform_values do |by_medication|
        by_medication.group_by(&:time)
        .transform_values do |by_time|
          by_time.sum { |p| p.quantity.to_i }
        end
      end.reject { |_time, sum| sum.zero? }
  end

  def self.history_for(patient, medication)
    patient.prescriptions
      .where(medication: medication)
      .order(:created_at)
      .map do |p|
        {
          quantity: p.quantity,
          time: p.time,
          action_type: p.action_type,
          created_at: p.created_at
        }
      end
  end
end
