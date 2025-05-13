# 🧠 Psychonnect

**Psychonnect** is a RESTful API developed in Ruby on Rails for managing psychiatric treatment, allowing control of medical prescriptions, patients, doctors and medications.

---

## ✨ Features

- Create, list, edit and delete **medications**
- Create **medical prescriptions**, with logic of:
  - Detect dose changes
  - History by time and substance
  - Automatic relationship between doctor and patient when prescribing
- History and current treatment by patient
- Register **users** with roles: `admin`, `physician` and `patient`
- Authentication with **JWT**
- **Role-based authorization**
- **Test coverage with RSpec and Rswag**

---

## 🚀 Stack

- Ruby on Rails 8
- PostgreSQL
- JWT
- RSpec + Rswag
- Rubocop + Brakeman
- GitHub Actions (CI/CD)

---

## 🔧 Installation

1. Clone the repository:

```
git clone https://github.com/your-user/psychonnect.git
cd psychonnect
```

2. *First option* is to simply run the setup.sh file:

```
./setup.sh
```

2. *Alternatively*, follow these steps:

```
bundle install
cp .env.example .env
bin/rails db:create db:migrate db:seed
bin/rails server
```


## 🛡️ Authentication
Create an user, sending `name`, `email`, and `password` to

```POST /users```

Log in by sending your email and password to

```POST /auth/login```

Receive a JWT token

Send this token in the header:

Authorization: Bearer <your_token>

📬 Main endpoints
bash
Always show details

Copy
POST /auth/login # Login with email and password
GET /users # List (admin only)

PATCH /users/:id/role # Role change (admin only)

GET /medications # List medications
POST /medications # Create medication
PUT /medications/:id # Update medication
DELETE /medications/:id # Remove medication

POST /prescriptions # Create prescription
GET /prescriptions # List current treatment
GET /prescriptions/history/:id # Patient history
🧪 Tests
Run the test suite:

bash
Always show details

Copy
bin/rspec
100% guaranteed coverage™ 🧼

📄 Swagger documentation
After running the server, access:

bash
Always show details

Copy
http://localhost:3000/api-docs
📌 ALL future
Web interface (React or Vue)

Side Effect Tracking

Medication Notifications and Reminders

Treatment Charts and Reports

👨‍⚕️ Developed by
Rodrigo (a.k.a. Gyodai)
More than a dev: a Rails warrior with a plan.

🧠 Project Philosophy
"The madness you have may be exactly what the world needs."
""