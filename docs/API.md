# Psychonnect API Documentation

Psychonnect is a RESTful service for managing psychiatric treatments. The API exposes resources for medications, prescriptions and users. All endpoints return JSON.

## Authentication

The API uses JWT for authentication. Obtain a token by sending credentials to `/login`.

```
POST /login
{
  "email": "user@example.com",
  "password": "secret"
}
```

Use the returned token in the `Authorization` header:

```
Authorization: Bearer <token>
```

## Users

### POST `/users`
Create a new user. Roles available: `patient`, `physician` or `admin`.

### GET `/users`
List all users (admin only).

### GET `/users/{id}`
Retrieve a single user. Users can only see their own data unless they are connected (patient/physician relationship).

### PUT `/users/{id}`
Update the authenticated user.

### PATCH `/users/{id}/role`
Change a user role (admin only).

### DELETE `/users/{id}`
Remove a user (admin only).

## Medications

### GET `/medications`
List medications.

### POST `/medications`
Create a medication.

### GET `/medications/{id}`
Retrieve a medication by id.

### PUT `/medications/{id}`
Update a medication.

### DELETE `/medications/{id}`
Delete a medication.

## Prescriptions

### GET `/prescriptions`
Show current treatment for a patient. Requires query parameter `patient_id` and an authenticated token.

### GET `/prescriptions/history/{patient_id}`
Show treatment history for a patient.

### POST `/prescriptions`
Create a prescription. Automatically links doctor and patient when needed.

### GET `/prescriptions/{id}`
Retrieve a prescription.

### PUT `/prescriptions/{id}`
Update a prescription.

### DELETE `/prescriptions/{id}`
Remove a prescription (admin only).

## Protected Endpoint Example

```
GET /secret
Authorization: Bearer <token>
```

Returns the authenticated user's basic information.

## Error format

Errors are returned in the following format:

```
{
  "error": "Description of what went wrong",
  "details": ["additional", "info"]
}
```

## Swagger

A complete OpenAPI specification is generated with `rswag`. After starting the server visit `http://localhost:3000/api-docs` to browse all endpoints interactively.

