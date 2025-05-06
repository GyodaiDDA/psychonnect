FactoryBot.define do
  substances = [ "Pregabalina", "Bupropiona", "Cronopianina", "Arritmomicina", "Superiorona" ]
  measures = [ "mg", "g", "mg/ml" ]

  factory :medication do
    substance { substances.sample }
    dosage { 50 }
    measure { measures.sample }
  end
end
