require 'swagger_helper'

RSpec.describe 'API Users', type: :request do
  path '/users' do
    post 'Creates new user' do
      tags 'Users'
      security []
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string, format: :email },
              password: { type: :string, format: :password },
              role: { type: :integer, enum: [ patient: 0, physician: 1, blocked: 9, admin: 10 ] }
            },
            required: [ 'name', 'email', 'password', 'role' ]
          }
        },
        required: ['user']
      }

      response '201', 'physician user created' do
        let!(:user) { { user: { name: 'Rodrigo', email: 'rodrigao@tenta.com', password: 'uLyt@2', role: 'physician' } } }
        run_test!
      end

      response '201', 'patient user created' do
        let!(:user) { { user: { name: 'Rodrigo', email: 'rodrigao@tenta.com', password: 'uLyt@2', role: 'patient' } } }
        run_test!
      end

      response '422', 'user without email not created' do
        let!(:user) { { user: { name: 'Rodrigo', email: 'rodrigao', password: 'uLyt@2', role: :patient } } }
        run_test!
      end

      response '422', 'user without password not created' do
        let!(:user) { { user: { name: 'Rodrigo', email: 'rodrigao@tenta.com', password: '', role: :patient } } }
        run_test!
      end

      response '422', 'user with role admin not created' do
        let!(:user) { { user: { name: 'Rodrigo', email: 'rodrigao@tenta.com', password: 'uLyt@2', role: :admin } } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Finds a specific user' do
      tags 'Users'
      security [ bearerAuth: [] ]
      produces 'application/json'

      response '200', 'user can see their own info' do
        let!(:user) { create(:user, :patient) }
        let(:id) { user.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        run_test!
      end

      response '200', 'user cannot see other user info' do
        let!(:user) { create(:user, :patient) }
        let!(:other_user) { create(:user, :physician) }
        let(:id) { user.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        
        run_test!
      end

      response '404', 'user not found' do
        let!(:user) { create(:admin) }
        let(:id) { 0 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        run_test!
      end
    end

    put 'Updates an user' do
      tags 'Users'
      security [ bearerAuth: [] ]
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string, format: :email }
        }
      }

      response '200', 'user updated' do
        let!(:user_record) { create(:user, :patient) }
        let(:id) { user_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user_record.id }, Rails.application.secret_key_base)}" }
        let(:user) { { name: 'Nome Atualizado' } }
        run_test!
      end

      response '422', 'non processable entity' do
        let!(:user_record) { create(:user, :patient) }
        let(:id) { user_record.id }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user_record.id }, Rails.application.secret_key_base)}" }
        let(:user) { { email: '' } }
        run_test!
      end

      response '401', 'access denied' do
        let(:id) { 0 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1 }, Rails.application.secret_key_base)}" }
        let(:user) { { name: 'Nome Qualquer' } }
        run_test!
      end
    end
  end
end
