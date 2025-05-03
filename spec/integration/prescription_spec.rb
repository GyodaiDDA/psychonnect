require 'swagger_helper'

RSpec.describe 'API Receitas', type: :request do
  path '/prescriptions' do
    get 'Lista todas os receitas' do
      tags 'Receitas'
      produces 'application/json'
      response '200', 'receitas listadas' do
        let!(:prescriptions) { 5.times { create(:prescription) } }
        let(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(5)
        end
      end

      response '401', 'sem token' do
        let(:Authorization) { nil }
        run_test!
      end
    end

    post 'Cadastra uma nova receita' do
      tags 'Receitas'
      consumes 'application/json'
      parameter name: :prescription, in: :body, schema: {
        type: :object,
        properties: {
          current_user_id: { type: :integer },
          patient_id: { type: :integer },
          physician_id: { tyṕe: :integer },
          medication_id: { type: :integer },
          quantity: { type: :float },
          action_type: { type: :integer, enum: [ 0, 2, 4, 6, 8, 10 ] },
          time: { type: :string },
          comment: { type: :text }
        },
        required: [ 'patient_id', 'physician_id', 'medication_id', 'quantity', 'time' ]
      }

      response '201', 'Receita cadastrada' do
        let!(:patient) { create(:user, :patient) }
        let!(:physician) { create(:user, :physician) }
        let!(:medication) { create(:medication) }
        let!(:Authorization) { "Bearer #{JWT.encode({ user_id: patient.id }, Rails.application.secret_key_base)}" }
        let!(:prescription) { {
          prescription: {
            current_user_id: patient.id,
            physician_id: physician.id,
            patient_id: patient.id,
            medication_id: medication.id,
            quantity: '3',
            time: '14:00'}
        } }
        run_test!
      end

      response '422', 'Receita sem quantidade não criada' do
        let!(:patient) { create(:user, :patient) }
        let!(:physician) { create(:user, :physician) }
        let!(:medication) { create(:medication) }
        let!(:Authorization) { "Bearer #{JWT.encode({ user_id: patient.id }, Rails.application.secret_key_base)}" }
        let!(:prescription) { {
          prescription: {
            current_user_id: patient.id,
            physician_id: physician.id,
            patient_id: patient.id,
            medication_id: medication.id,
            quantity: '',
            time: '14:00'}
        } }
        run_test!
      end
    end
  end
end
