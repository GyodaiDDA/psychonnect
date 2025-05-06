require 'swagger_helper'

RSpec.describe 'API Medications', type: :request do
  path '/medications' do
    get 'Lista todas as medicações' do
      tags 'Medicações'
      produces 'application/json'
      security []

      response '200', 'lista retornada com sucesso' do
        before do
          3.times do
            create(:medication)
          end
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.size).to eq(3)
        end
      end
    end

    post 'Cria uma nova medicação' do
      tags 'Medicações'
      consumes 'application/json'
      security []
      parameter name: :medication, in: :body, schema: {
        type: :object,
        properties: {
          substance: { type: :string },
          dosage: { type: :float },
          measure: { type: :string }
        }
      }

      response '201', 'medicação criada com sucesso' do
        let!(:medication) { create(:medication) }
        run_test!
      end

      response '422', 'dados inválidos' do
        let(:medication) { { substance: '', dosage: 50, measure: 'g' } }
        run_test!
      end
    end
  end

  path '/medications/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Exibe uma medicação específica' do
      tags 'Medicações'
      produces 'application/json'
      security []

      response '200', 'medicação encontrada' do
        let!(:med) { create(:medication) }
        let(:id) { med.id }
        run_test!
      end

      response '404', 'medicação não encontrada' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Atualiza uma medicação' do
      tags 'Medicações'
      consumes 'application/json'
      security []
      parameter name: :medication, in: :body, schema: {
        type: :object,
        properties: {
          substance: { type: :string }
        }
      }

      response '200', 'medicação atualizada' do
        let!(:med) { create(:medication) }
        let(:id) { med.id }
        let(:medication) { { substance: 'NovaSubstância' } }
        run_test!
      end

      response '404', 'medicação não encontrada' do
        let(:id) { 0 }
        let(:medication) { { substance: 'NovaSubstância' } }
        run_test!
      end

      response '422', 'medicação inválida' do
        let!(:medication_record) { create(:medication) }
        let(:id) { medication_record.id }
        let(:medication) { { substance: '' } }
        run_test!
      end
    end

    delete 'Remove uma medicação' do
      tags 'Medicações'
      security []

      response '204', 'medicação removida com sucesso' do
        let!(:med) { create(:medication) }
        let(:id) { med.id }
        run_test!
      end

      response '404', 'medicação não encontrada' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
