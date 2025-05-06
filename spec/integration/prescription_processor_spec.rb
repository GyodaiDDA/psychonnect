require 'rails_helper'

RSpec.describe PrescriptionProcessor do
  let(:patient) { create(:user, :patient) }
  let(:physician) { create(:user, :physician) }
  let(:medication) { create(:medication) }

  let(:valid_params) do
    {
      patient_id: patient.id,
      physician_id: physician.id,
      # current_user_id: physician.id,
      medication_id: medication.id,
      quantity: 2,
      time: "10:00"
    }
  end

  describe ".call" do
    context "com prescrição nova" do
      it "cria uma nova prescrição e retorna status :created" do
        result = described_class.call(valid_params, physician)

        expect(result[:status]).to eq(:created)
        expect(result[:message]).to include("adicionado ao tratamento")
        expect(Prescription.count).to eq(1)
      end
    end

    context "com aumento de dose" do
      before do
        create(:prescription, patient:, physician:, medication:, quantity: 1, time: "10:00")
      end

      it "retorna :increase_dosis" do
        result = described_class.call(valid_params.merge(quantity: 2), physician)
        expect(result[:message]).to include("aumentada")
      end
    end

    context "com redução de dose" do
      before do
        create(:prescription, patient:, physician:, medication:, quantity: 2, time: "10:00")
      end

      it "retorna :reduce_dosis" do
        result = described_class.call(valid_params.merge(quantity: 1), physician)
        expect(result[:message]).to include("reduzida")
      end
    end

    context "com mesma dose" do
      before do
        create(:prescription, patient:, physician:, medication:, quantity: 2, time: "10:00")
      end

      it "retorna :no_changes" do
        result = described_class.call(valid_params.merge(quantity: 2), physician)
        expect(result[:message]).to include("Nenhuma alteração")
      end
    end

    context "com quantidade zero" do
      before do
        create(:prescription, patient:, physician:, medication:, quantity: 1, time: "10:00")
      end

      it "retorna :remove_medication" do
        result = described_class.call(valid_params.merge(quantity: 0), physician)
        expect(result[:message]).to include("retirada")
      end
    end

    context "com parâmetros inválidos" do
      it "retorna erro se medicação não existir" do
        params = valid_params.merge(medication_id: nil)
        result = described_class.call(params, physician)
        expect(result[:status]).to eq(:unprocessable_entity)
      end

      it "retorna erro se usuário não for médico nem paciente" do
        outsider = create(:user, :patient) # sem role
        result = described_class.call(valid_params, outsider)
        expect(result[:status]).to eq(:unprocessable_entity)
        expect(result[:message]).to match(/não autorizado/)
      end
    end
  end
end
