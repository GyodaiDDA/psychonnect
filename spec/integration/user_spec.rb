require 'swagger_helper'

RSpec.describe 'API Users', type: :request do
  path '/users' do
    get 'Lista todos os usuários' do
      tags 'Usuários'
      security [ bearerAuth: [] ]
      produces 'application/json'

      response '200', 'usuários listados' do
        let!(:admin) { create(:user, :admin) }
        let!(:users) { 3.times { create(:user, :patient) } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(4)
        end
      end

      response '401', 'sem token' do
        let(:Authorization) { nil }
        run_test!
      end
    end

    post 'Cria um novo usuário' do
      tags 'Usuários'
      security []
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string, format: :email },
          password: { type: :string, format: :password },
          role: { type: :integer, enum: [ 0, 1, 10 ] }
        },
        required: [ 'name', 'email', 'password', 'role' ]
      }

      response '201', 'usuário criado' do
        let!(:user) { { user: { name: 'Rodrigo', email: 'rodrigao@tenta.com', password: 'uLyt@2', role: 10 } } }
        run_test!
      end

      response '422', 'usuário sem e-mail não criado' do
        let!(:user) { { user: { name: 'Rodrigo', email: 'rodrigao', password: 'uLyt@2', role: 10 } } }
        run_test!
      end

      response '422', 'usuário sem senha não criado' do
        let!(:user) { { user: { name: 'Rodrigo', email: 'rodrigao@tenta.com', password: '', role: 10 } } }
        run_test!
      end
    end
  end
end
