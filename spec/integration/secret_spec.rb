require 'swagger_helper'

RSpec.describe 'API secret', type: :request do
  path '/secret' do
    get 'Endpoint protegido' do
      tags 'Auth'
      security [ bearerAuth: [] ]
      produces 'application/json'

      response '200', 'acesso permitido' do
        let(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }

        run_test!
      end

      response '401', 'acesso negado' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end
end
