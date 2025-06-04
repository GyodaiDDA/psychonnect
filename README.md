# 🧠 Psychonnect

Psychonnect is a Ruby on Rails API for managing psychiatric treatments. It allows doctors to prescribe medications to patients while keeping track of dose changes and treatment history.

---

## ✨ Features

- CRUD for **medications**
- Create and update **prescriptions** with dose change detection
- Patient treatment history and current regimen
- User management with roles: `admin`, `physician` and `patient`
- JWT based authentication and role authorization
- RSpec test suite with Swagger documentation

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

1. Clone the repository and enter the folder

```bash
git clone https://github.com/your-user/psychonnect.git
cd psychonnect
```

2. Copy the environment file and install dependencies

```bash
cp env.example .env
bundle install
```

3. Prepare the database and start the server

```bash
bin/rails db:create db:migrate
bin/rails server
```

You can also run `./setup.sh` to perform all the steps above automatically.

---

## 🛡️ Authentication

Create an account by sending `name`, `email` and `password` to **POST `/users`**. Then obtain a token with your credentials:

```bash
POST /login
{
  "email": "user@example.com",
  "password": "secret"
}
```

Use the token in subsequent requests:

```
Authorization: Bearer <token>
```

---

## 📬 Main Endpoints

- `POST /login` – obtain authentication token
- `GET /users` – list users (admin only)
- `PATCH /users/:id/role` – change user role (admin only)
- `GET /medications` – list medications
- `POST /medications` – create medication
- `POST /prescriptions` – create prescription
- `GET /prescriptions` – list current treatment
- `GET /prescriptions/history/:patient_id` – treatment history

See [docs/API.md](docs/API.md) for full endpoint documentation.

---

## 🧪 Tests

Run the test suite with:

```bash
bin/rspec
```

---

## 📄 Swagger

After running the server, access [`http://localhost:3000/api-docs`](http://localhost:3000/api-docs) to view the interactive Swagger documentation.

---

## 👨‍⚕️ Developed by

Rodrigo (a.k.a. Gyodai)

