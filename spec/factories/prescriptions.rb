FactoryBot.define do
  factory :prescription do
    physician { create(:user, :physician) }
    patient { create(:user, :patient) }
    medication_id { create(:medication).id }
    quantity { rand(1..3) }
    time { "#{rand(10..22)}:00" }
    comment { "This #{[ "is", "will be", "should be" ].sample} a comment." }
    current_user_id { physician.id }
  end
end
