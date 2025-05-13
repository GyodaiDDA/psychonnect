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
  end

  factory :admin, class: 'User' do
    name { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { :admin }
  end
end
