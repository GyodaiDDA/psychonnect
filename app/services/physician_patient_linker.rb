# When a prescription is created, creates a connection
# between the physician and the patient
class PhysicianPatientLinker
  def self.call(physician, patient)
    return unless physician&.physician? && patient&.patient?

    create_link(physician, patient) unless link_exists(physician, patient)
  end

  def self.create_link(physician, patient)
    PhysicianPatient.create!(
      physician: physician,
      patient: patient
    )
  end

  def self.link_exists(physician, patient)
    PhysicianPatient.find_by(physician_id: physician.id, patient_id: patient.id)
  end
end
