require 'swagger_helper'

RSpec.describe 'API Remédios', type: :request do
  path '/medications' do
    get 'Lista todos os remédios' do
      tags 'Remédios'
      produces 'application/json'
      response '200', 'remédios listados' do
        let!(:medications) { 5.times { create(:medication) } }
        let(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(5)
        end
      end

      response '401', 'sem token' do
        let(:Authorization) { nil }
        run_test!
      end
    end

    post 'Cadastra um novo remédio' do
      tags 'Remédios'
      consumes 'application/json'
      parameter name: :medication, in: :body, schema: {
        type: :object,
        properties: {
          substance: { type: :string },
          dosage: { type: :float },
          unit: { type: :integer, enum: [ 0, 1, 2 ] }
        },
        required: [ 'substance', 'dosage', 'unit' ]
      }

      response '201', 'remédio cadastrado' do
        let(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        let!(:medication) { { medication: { substance: 'Porcabalina Cubica', dosage: '160', unit: 'g' } } }
        run_test!
      end

      response '422', 'remédio sem dosagem não criado' do
        let(:user) { create(:user, :patient) }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)}" }
        let!(:medication) { { medication: { substance: 'Porcabalina Cubica', dosage: '', unit: 'g' } } }
        run_test!
      end
    end
  end
end
