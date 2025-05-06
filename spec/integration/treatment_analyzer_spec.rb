require 'swagger_helper'

RSpec.describe TreatmentAnalyzer do
  let(:patient) { create(:user, :patient) }
  let(:physician) { create(:user, :physician) }
  let(:fst_medication) { create(:medication) }
  let(:snd_medication) { create(:medication) }

  before do
    # primeira receita, primeiro remédio, 2 comprimidos às 10:00
    create(:prescription, patient:, physician:, medication: fst_medication, quantity: 2, time: "10:00")
    # alteração da dose, 1 comprimido às 10:00
    create(:prescription, patient:, physician:, medication: fst_medication, quantity: 1, time: "10:00")
    # novo horário, 1 comprimido às 20:00
    create(:prescription, patient:, physician:, medication: fst_medication, quantity: 1, time: "20:00")
    # segunda substância, 3 comprimidos às 13:00
    create(:prescription, patient:, physician:, medication: snd_medication, quantity: 3, time: "13:00")
    # remove dose do segundo remédio
    create(:prescription, patient:, physician:, medication: snd_medication, quantity: 0, time: "13:00")
  end

  describe ".current_treatment_for" do
    it "retorna apenas as prescrições com quantity > 0 e mais recentes" do
      result = described_class.current_treatment_for(patient)

      expect(result).to all(be_a(Prescription))
      expect(result.map(&:quantity)).to all(be > 0)
      expect(result.map(&:row_number)).to all(eq(1))
      expect(result.map(&:medication_id)).not_to include(snd_medication.id)
      expect(result.map(&:time)).to include("10:00")
      expect(result.map(&:time)).to include("20:00")
    end

    it "filtra corretamente por medicação" do
      result = described_class.current_treatment_for(patient, medication: fst_medication)
      expect(result.map(&:medication_id).uniq).to eq([ fst_medication.id ])
    end

    it "filtra corretamente por horário" do
      result = described_class.current_treatment_for(patient, time: "10:00")
      expect(result.map(&:time).uniq).to eq([ "10:00" ])
    end

    it "mostra a quantidade atualizada para o horário" do
      result = described_class.current_treatment_for(patient, medication: fst_medication, time: "10:00")
      expect(result.map(&:quantity).uniq).to eq([ 1 ])
    end
  end
end
