FactoryBot.define do
  substances = %w[Acamprosato Alprazolam Ácido valproico Amantadina Amissulprida Amitriptilina Amoxapina Aripiprazol Atomoxetina Anfebutamona Anfepramona Buprenorfina Bupropiona Buspirona Carbamazepina Carbonato de lítio Ciamemazina Citalopram Clomipramina Clordiazepóxido Clorpromazina Clonazepam Cloxazolam Clozapina Desipramina Dextroanfetamina Diazepam Disulfiram Divalproato Doxepina Desvenlafaxina Escitalopram Fenitoína Fenobarbital Flufenazina Fluoxetina Flupentixol Flurazepam Fluvoxamina Fenergan (Prometazina) Gabapentina Gadernal Haloperidol Imipramina KLamotrigina Levomepromazina Lítio Lorazepam LoxapineLevozine Maprotilina Melperona Mesoridazina Metadona Metilfenidato Mirtazapina Moclobemide Modafinil Naltrexona Nefazodona Nortriptilina Olanzapina Oxazepam Paroxetina Pemoline Perfenazina Pimozida Pipotiazina Primidona Prirocailina (Pacinone) Quetiapina Reboxetina Risperidona Rivotril (Clonazepam) Sertralina Sibutramina Sulpirida-Serenal Temazepam Tianeptina Tiaprida Tioridazina Tiotixene Topiramato Tranilcipromina Trazodona Triazolam Trifluoperazina Tri-hexifenidilo Trimipramina Triticum Venlafaxina Zaleplon Ziprasidona Zolpidem Zopiclone Zuclopentixol]
  measures = ['mg', 'g', 'mg/ml']
  dosage = [25, 50, 75, 100, 150, 300, 600, 800, 1200, 1, 0.5]

  factory :medication do
    substance { substances.sample }
    dosage { dosage.sample }
    measure { measures.sample }
  end
end
