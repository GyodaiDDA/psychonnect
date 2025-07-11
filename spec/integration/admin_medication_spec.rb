require 'swagger_helper'

RSpec.describe 'API Admin', type: :request do
  path '/admin/medications/{id}' do
    parameter name: :id, in: :path, type: :string, required: true
    parameter name: :medication, in: :body, schema: {
        type: :object,
        properties: {
          substance: { type: :string },
          dosage: { type: :number },
          measure: { type: :string }
        },
        required: %w[substance dosage measure]
      }
    
    delete 'Deletes a medication' do
      tags 'Admin'
      security [ bearerAuth: [] ]

      response '204', 'medication successfully deleted' do
        let!(:medication) { create(:medication) }
        let!(:admin) { create(:admin) }
        let(:id) { medication.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '404', 'medication not found' do
        let!(:admin) { create(:admin) }
        let(:id) { 9999 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '403', 'not authorized' do
        let!(:medication) { create(:medication) }
        let!(:user) { create(:user, :patient) }
        let(:id) { medication.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        run_test!
      end
    end
  end
end
