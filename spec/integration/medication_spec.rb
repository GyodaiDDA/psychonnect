require 'swagger_helper'

RSpec.describe 'API Medications', type: :request do
  path '/medications' do
    get 'List all medications' do
      tags 'Medication'
      produces 'application/json'
      security []

      response '200', 'List returned with success' do
        before do
          create(:medication, substance: 'Pregabalina')
          create(:medication, substance: 'Cronopianina')
          create(:medication, substance: 'Bupropiona')
        end

        run_test! do |response|
          response = JSON.parse(response.body)
          expect(response['data'].size).to eq(3)
        end
      end
    end

    post 'Create new medication' do
      tags 'Medication'
      consumes 'application/json'
      security []
      parameter name: :medication, in: :body, schema: {
        type: :object,
        properties: {
          substance: { type: :string },
          dosage: { type: :number },
          measure: { type: :string }
        },
        required: %w[substance dosage measure]
      }

      response '201', 'medicação criada com sucesso' do
        let(:medication) { {substance: 'Cronapianina', dosage: 250, measure: 'mg'} }
                
        run_test! do |response|
          expect(response.status).to eq(201)
          body = JSON.parse(response.body)
          expect(body['message']).to eq(I18n.t('api.success.item_created'))
          expect(Medication.last.substance).to eq('Cronapianina')
        end
      end

      response '422', 'Invalid data', content: {
        'application/json' => {
          example: {
            status: 'unprocessable_entity',
            message: 'Invalid parameters',
            errors: ["Dosage can't be blank"]
          }
        }
      } do
        let(:medication) { { substance: '', dosage: nil, measure: '' } }

        run_test! do |response|
          expect(response.status).to eq(422)
          JSON.parse(response.body)
        end
      end
    end
  end

  path '/medications/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Finds a specific medication' do
      tags 'Medication'
      produces 'application/json'
      security []

      response '200', 'Medication found' do
        let!(:medication) { create(:medication, substance: 'Pregabalina') }
        let(:id) { medication.id }

        run_test! do |response|
          expect(response.status).to eq(200)
          body = JSON.parse(response.body)
          expect(body['data']['substance']).to eq('Pregabalina')
        end
      end

      response '404', 'Medication not found', content: {
        'application/json' => {
          example: {
            status: 'not_found',
            message: 'Item not found'
          }
        }
      } do
        let(:id) { 0 }

        run_test! do |response|
          expect(response.status).to eq(404)
          body = JSON.parse(response.body)
          expect(body['error']).to eq(I18n.t('api.error.not_found', item: 'medication'))
        end
      end
    end
  end
end
