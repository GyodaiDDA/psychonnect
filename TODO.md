# Modelos atualizados do Psychonnect

# User
# - name :string
# - role :integer (enum: [:paciente, :medica])
# - email :string
# - password_digest :string

# TratamentoAtual
# - user_id :references
# - created_at :datetime (automático)
# - observacoes :text

# Medicamento
# - nome :string
# - dose :string

# Feedback
# - user_id :references
# - data :date
# - humor :integer
# - efeitos_colaterais :text
# - tomou_medicacao :boolean
# - observacoes :text

# Receita
# - tratamento_atual_id :references
# - user_id :references (quem criou a entrada)
# - medicamento_id :references
# - action :integer (enum: [:add, :remove])
# - horario :string (ou json/array futuramente)
# - obs :text
# - created_at :datetime