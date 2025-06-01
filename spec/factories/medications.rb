FactoryBot.define do
  substances = %w[Pregabalina Bupropiona Cronopianina Arritmomicina Superiorona]
  measures = ['mg', 'g', 'mg/ml']
  dosage = [25, 50, 75, 100, 150, 300, 600, 800, 1200, 1, 0.5]

  factory :medication do
    substance { substances.sample }
    dosage { dosage.sample }
    measure { measures.sample }
  end
end
