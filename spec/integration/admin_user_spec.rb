require 'swagger_helper'

RSpec.describe 'API Admin', type: :request do
  path '/admin/users/{id}' do
    parameter name: :id, in: :path, type: :string, required: true
    parameter name: :user_payload, in: :body, schema: {
      type: :object,
      properties: {
        user: {
          type: :object,
          properties: {
            name: { type: :string },
            email: { type: :string, format: :email },
            password: { type: :string, format: :password },
            role: { type: :integer, enum: [patient: 0, physician: 1, blocked: 9, admin: 10] }
          }
        }
      },
      required: ['user']
    }

    patch 'Changes an user role' do
      tags 'Admin'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      let!(:user) { create(:user, :patient) }
      let(:id) { user.id }

      response '200', 'Role successfully updated' do
        let!(:admin) { create(:admin) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        let(:user_payload) { { user: { role: :physician } } }

        run_test! do |response|

          expect(response.status).to eq(200)
        end
      end

      response '401', 'Not authorized' do
        let(:Authorization) { nil }
        let(:user_payload) { { user: { role: 'physician' } } }

        run_test! do |response|
          expect(response.status).to eq(401)
          body = JSON.parse(response.body)
          expect(body['error']).to eq(I18n.t('api.error.unauthorized'))
        end
      end

      response '403', 'User is not admin' do
        let!(:non_admin) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: non_admin.id }, Rails.application.secret_key_base)}" }
        let(:user_payload) { { user: { role: 'admin' } } }

        run_test! do |response|
          expect(response.status).to eq(403)
          body = JSON.parse(response.body)
          expect(body['error']).to eq(I18n.t('api.error.forbidden'))
        end
      end
    end

    delete 'Deletes an user' do
      tags 'Admin'
      security [ bearerAuth: [] ]

      response '204', 'user successfully deleted' do
        let!(:user_record) { create(:user, :patient) }
        let!(:admin) { create(:admin) }
        let(:id) { user_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '404', 'user not found' do
        let!(:admin) { create(:admin) }
        let(:id) { 0 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '403', 'not authorized' do
        let!(:user_record) { create(:user, :patient) }
        let(:id) { user_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: id }, Rails.application.secret_key_base)}" }
        run_test!
      end
    end
  end
end
