require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/login' do
    post 'Login do usuário' do
      tags 'Autenticação'
      consumes 'application/json'
      produces 'application/json'
      security []
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email },
          password: { type: :string, format: :password }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'login bem-sucedido' do
        let!(:user) { create(:user, :patient, password: '123456') }

        let(:credentials) do
          {
            email: user.email,
            password: '123456'
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['token']).to be_present
          expect(data['user']['email']).to eq(user.email)
        end
      end

      response '401', 'login falhou (credenciais inválidas)' do
        let!(:user) { create(:user, password: '123456', role: :patient) }

        let(:credentials) do
          {
            email: user.email,
            password: 'senhaerrada'
          }
        end

        run_test! do |response|
          expect(response.status).to eq(401)
          expect(response.body).to include('Credenciais inválidas')
        end
      end

      response '401', 'usuário não existe' do
        let(:credentials) do
          {
            email: 'naoexiste@email.com',
            password: 'qualquercoisa'
          }
        end

        run_test! do |response|
          expect(response.status).to eq(401)
          expect(response.body).to include('Credenciais inválidas')
        end
      end
    end
  end
end
