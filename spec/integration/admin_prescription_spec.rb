require 'swagger_helper'

RSpec.describe 'API Admin', type: :request do
  path '/admin/prescriptions/{id}' do
    parameter name: :id, in: :path, type: :string, required: true
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
      required: ['prescription']
    }

    delete 'Deletes a prescription' do
      tags 'Admin'
      security [bearerAuth: []]
      
      response '204', 'prescription deleted by admin' do
        let!(:prescription_record) { create(:prescription) }
        let(:admin) { create(:admin) }
        let(:id) { prescription_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '404', 'prescription not found' do
        let!(:admin) { create(:admin) }
        let(:id) { 9999 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '403', 'unauthorized' do
        let!(:prescription_record) { create(:prescription) }
        let!(:user) { create(:user, :patient) }
        let(:id) { prescription_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        run_test!
      end
    end
  end
end
