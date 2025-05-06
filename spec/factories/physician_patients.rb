FactoryBot.define do
  factory :physician_patient do
    association :physician, factory: [ :user, :physician ]
    association :patient, factory: [ :user, :patient ]
  end
end
