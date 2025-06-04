require 'rails_helper'

RSpec.describe PrescriptionProcessor do
  let(:patient) { create(:user, :patient) }
  let(:physician) { create(:user, :physician) }
  let(:medication) { create(:medication) }

  let(:valid_params) do
    {
      patient_id: patient.id,
      physician_id: physician.id,
      current_user_id: physician.id,
      medication_id: medication.id,
      quantity: 2,
      time: '10:00'
    }
  end

  describe '.call' do
    context 'new prescription' do
      it 'creates new prescription with status :created' do
        result = described_class.call(valid_params, physician)

        expect(result[:status]).to eq(:created)
        expect(result[:message]).to include('Successfully created')
        expect(Prescription.count).to eq(1)
      end
    end

    context 'increasing dosis' do
      before do
        create(:prescription, patient:, physician:, medication:, quantity: 1, time: '10:00')
      end

      it 'returns :increase_dosis' do
        result = described_class.call(valid_params.merge(quantity: 2), physician)
        expect(result[:message]).to include('increased')
      end
    end

    context 'reduces dosis' do
      before do
        create(:prescription, patient:, physician:, medication:, quantity: 2, time: '10:00')
      end

      it 'returns :reduce_dosis' do
        result = described_class.call(valid_params.merge(quantity: 1), physician)
        expect(result[:message]).to include('reduced')
      end
    end

    context 'same dosis' do
      before do
        create(:prescription, patient:, physician:, medication:, quantity: 2, time: '10:00')
      end

      it 'returns :no_changes' do
        result = described_class.call(valid_params.merge(quantity: 2), physician)
        expect(result[:message]).to include('already prescribed')
      end
    end

    context 'removes medication - zero quantity' do
      before do
        create(:prescription, patient:, physician:, medication:, quantity: 1, time: '10:00')
      end

      it 'returns :remove_medication' do
        result = described_class.call(valid_params.merge(quantity: 0), physician)
        expect(result[:message]).to include('removed')
      end
    end
  end
end
