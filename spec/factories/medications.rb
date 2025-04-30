substances = [ "Pregabalina", "Bupropiona", "Cronopianina", "Arritmomicina", "Superiorona" ]

FactoryBot.define do
  factory :medication do
    substance { substances.sample }
    dosage { 10*rand(1..80) }
    unit { [ 'mg', 'g', 'mg/ml' ].sample }
  end
end
