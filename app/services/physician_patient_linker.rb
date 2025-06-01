# When a prescription is created, creates a connection
# between the physician and the patient
class PhysicianPatientLinker
  def self.call(physician, patient)
    return unless physician&.physician? && patient&.patient?

    PhysicianPatient.create!(
      physician: physician,
      patient: patient
    )
  end
end
