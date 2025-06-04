require 'swagger_helper'

RSpec.describe 'API Prescription Lists', type: :request do
  let!(:patient) { create(:user, :patient) }
  let!(:physician) { create(:user, :physician) }
  let!(:medication1) { create(:medication) }
  let!(:medication2) { create(:medication) }
  let(:Authorization) { "Bearer #{JWT.encode({ user_id: physician.id }, Rails.application.secret_key_base)}" }

  before do
    create(:prescription, patient:, physician:, medication: medication1, quantity: 2, time: '10:00')
    create(:prescription, patient:, physician:, medication: medication1, quantity: 1, time: '10:00') # mais recente
    create(:prescription, patient:, physician:, medication: medication1, quantity: 1, time: '20:00')
    create(:prescription, patient:, physician:, medication: medication2, quantity: 3, time: '14:00')
    create(:prescription, patient:, physician:, medication: medication2, quantity: 0, time: '14:00') # removido
  end

  path '/prescriptions' do
    get 'Consults current treatment' do
      tags 'Prescriptions'
      security [bearerAuth: []]
      produces 'application/json'
      parameter name: :patient_id, in: :query, type: :integer, required: true
      parameter name: :medication_id, in: :query, type: :integer, required: false
      parameter name: :time, in: :query, type: :string, required: false

      response '200', 'returns current treament' do
        let(:patient_id) { patient.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.size).to be >= 1
        end
      end

      response '404', 'patient not found' do
        let(:patient_id) { 9999 }
        run_test!
      end
    end
  end

  path '/prescriptions/history/{patient_id}' do
    get 'Consults treatment history' do
      tags 'Prescriptions'
      security [bearerAuth: []]
      produces 'application/json'
      parameter name: :patient_id, in: :path, type: :integer, required: true
      parameter name: :medication_id, in: :query, type: :integer, required: false
      parameter name: :time, in: :query, type: :string, required: false

      response '200', 'complete treatment history' do
        let(:patient_id) { patient.id }
        run_test!
      end

      response '200', 'medication treatment history' do
        let(:patient_id) { patient.id }
        let(:medication_id) { medication1.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.all? { |p| p['medication_id'] == medication1.id }).to be true
        end
      end

      response '200', 'time treatment history' do
        let(:patient_id) { patient.id }
        let(:time) { '10:00' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.all? { |p| p['time'] == '10:00' }).to be true
        end
      end

      response '404', 'patient not found' do
        let(:patient_id) { 9999 }
        run_test!
      end
    end
  end
end
