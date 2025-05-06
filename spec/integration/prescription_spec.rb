require 'swagger_helper'

RSpec.describe 'API Prescriptions', type: :request do
  path '/prescriptions' do
    post 'Cria uma nova prescrição' do
      tags 'Prescrições'
      security [ bearerAuth: [] ]
      consumes 'application/json'
      parameter name: :prescription, in: :body, schema: {
        type: :object,
        properties: {
          patient_id: { type: :integer },
          physician_id: { type: :integer },
          current_user_id: { type: :integer },
          medication_id: { type: :integer },
          quantity: { type: :number },
          time: { type: :string }
        },
        required: [ 'patient_id', 'physician_id', 'current_user_id', 'medication_id', 'quantity', 'time' ]
      }

      response '201', 'prescrição criada com sucesso' do
        let(:patient) { create(:user, :patient) }
        let(:physician) { create(:user, :physician) }
        let(:medication) { create(:medication) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: physician.id }, Rails.application.secret_key_base)}" }

        let(:prescription) do
          {
            patient_id: patient.id,
            physician_id: physician.id,
            current_user_id: physician.id,
            medication_id: medication.id,
            quantity: '2',
            time: "08:00"
          }
        end

        run_test!
      end
      
      response '422', 'retorna erro se a receita for inválida' do
        let(:patient) { create(:user, :patient) }
        let(:physician) { create(:user, :physician) }
        let(:medication) { create(:medication) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: physician.id }, Rails.application.secret_key_base)}" }

        let(:prescription) do
          {
            patient_id: patient.id,
            physician_id: physician.id,
            current_user_id: physician.id,
            medication_id: medication.id,
            quantity: '',
            time: "08:00"
          }
        end
          
        run_test!
      end
    end
  end

  path '/prescriptions/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Exibe uma prescrição específica' do
      tags 'Prescrições'
      security [ bearerAuth: [] ]
      produces 'application/json'

      response '200', 'prescrição encontrada' do
        let!(:prescription) { create(:prescription) }
        let(:id) { prescription.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: prescription.patient.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '404', 'prescrição não encontrada' do
        let(:id) { 0 }
        let!(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        run_test!
      end
    end

    put 'Atualiza uma prescrição' do
      tags 'Prescrições'
      security [ bearerAuth: [] ]
      consumes 'application/json'
      parameter name: :prescription, in: :body, schema: {
        type: :object,
        properties: {
          quantity: { type: :number },
          time: { type: :string }
        }
      }

      response '200', 'prescrição atualizada' do
        let!(:prescription_record) { create(:prescription) }
        let(:id) { prescription_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: prescription_record.patient.id }, Rails.application.secret_key_base)}" }
        let(:prescription) { { quantity: 2 } }
        run_test!
      end

      response '404', 'prescrição não encontrada' do
        let(:id) { 0 }
        let!(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        let(:prescription) { { quantity: 2 } }
        run_test!
      end

      response '422', 'medicação inválida' do
        let!(:prescription_record) { create(:prescription) }
        let(:id) { prescription_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: prescription_record.patient.id }, Rails.application.secret_key_base)}" }
        let(:prescription) { { quantity: '' } }
        run_test!
      end
    end

    delete 'Remove uma prescrição' do
      tags 'Prescrições'
      security [ bearerAuth: [] ]

      response '204', 'prescrição removida' do
        let!(:prescription_record) { create(:prescription) }
        let(:id) { prescription_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: prescription_record.patient.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '404', 'prescrição não encontrada' do
        let(:id) { 0 }
        let!(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        run_test!
      end
    end
  end
end
