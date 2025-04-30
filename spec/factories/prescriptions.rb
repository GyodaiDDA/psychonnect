FactoryBot.define do
  factory :prescription do
    user_id { create(:user, :physician).id }
    medication_id { create(:medication).id }
    quantity { rand(1..3) }
    time { "#{rand(10..22)}:00" }
    comment { "This #{["is","will be", "should be"].sample} a comment." }
    
    trait :add do
      action_type { :add }
    end
    
    trait :sub do
      action_type { :sub }
    end
  end
end