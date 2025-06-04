require 'swagger_helper'

RSpec.describe 'API secret', type: :request do
  path '/secret' do
    get 'protected endpoint' do
      tags 'Auth'
      security [bearerAuth: []]
      produces 'application/json'

      response '200', 'access granted' do
        let(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }

        run_test!
      end

      response '401', 'Invalid Token (JWT::DecodeError)' do
        let(:Authorization) { 'Bearer INVALID.TOKEN.STRING' }
        run_test! do |response|
          expect(response.status).to eq(401)
          expect(response.body).to include('Access denied')
        end
      end

      response '401', 'User not found (ActiveRecord::RecordNotFound)' do
        let(:Authorization) do
          token = JWT.encode({ user_id: 999_999 }, Rails.application.secret_key_base)
          "Bearer #{token}"
        end
        run_test! do |response|
          expect(response.status).to eq(401)
          expect(response.body).to include('Access denied')
        end
      end
    end
  end
end
