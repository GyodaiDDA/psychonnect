require 'swagger_helper'

RSpec.describe 'API Role Updates', type: :request do
  path '/users/{id}/role' do
    parameter name: :id, in: :path, type: :string

    patch 'Atualiza o papel de um usuário' do
      tags 'Usuários'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]

      parameter name: :role, in: :query, type: :string, enum: %w[patient physician admin], required: true

      let!(:user) { create(:user, :patient) }
      let(:id) { user.id }

      response '200', 'role atualizado com sucesso' do
        let!(:admin) { create(:user, :admin) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        let(:role) { 'physician' }

        run_test!
      end

      response '401', 'sem autorização' do
        let(:Authorization) { nil }
        let(:role) { 'physician' }
        run_test!
      end

      response '401', 'usuário não é admin' do
        let!(:non_admin) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: non_admin.id }, Rails.application.secret_key_base)}" }
        let(:role) { 'admin' }
        run_test!
      end

      response '422', 'role inválido' do
        let!(:admin) { create(:user, :admin) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base)}" }
        let(:role) { 'hacker' }

        run_test!
      end
    end
  end
end
