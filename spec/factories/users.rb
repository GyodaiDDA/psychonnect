FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :patient do
      role { 'patient' }
    end

    trait :physician do
      role { 'physician' }
    end

    trait :admin do
      role { 'admin' }
    end
  end
end
