require 'swagger_helper'

RSpec.describe "Treatment Analyzer", TreatmentAnalyzer do
  let(:patient) { create(:user, :patient) }
  let(:physician) { create(:user, :physician) }
  let(:medication) { create(:medication) }

  before do
    # primeira receita, 2 comprimidos às 10:00
    create(:prescription, patient: patient, physician: physician, medication: medication, quantity: 2, time: "10:00")
    # alteração da dose, -1 comprimido às 10:00
    create(:prescription, patient: patient, physician: physician, medication: medication, quantity: 1, time: "10:00")
    # adiciona um comprimido às 20:00
    create(:prescription, patient: patient, physician: physician, medication: medication, quantity: 1, time: "20:00")
    # remove o compridido das 20:00
    create(:prescription, patient: patient, physician: physician, medication: medication, quantity: 0, time: "10:00")
  end

  describe ".current_treatment_for" do
    it "mostra apenas o tratamento atual (dose > 0)" do
      result = described_class.current_treatment_for(patient)
      expect(result.keys).to include(medication)
      expect(result[medication].values).to include("20:00")
      expect(result[medication].values).not_to include("10:00")
    end
  end
end
