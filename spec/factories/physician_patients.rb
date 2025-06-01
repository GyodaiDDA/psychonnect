FactoryBot.define do
  factory :physician_patient do
    association :physician, factory: %i[user physician]
    association :patient, factory: %i[user patient]
  end
end
