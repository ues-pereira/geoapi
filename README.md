# Geolocation API (In Development)

This is a **Geolocation API** in development, designed to provide services for address lookups and their respective geographical coordinates. The primary goal of this project is to **explore and learn more about hexagonal architecture**, also known as **Ports** and **Adapters**.

## Technologies used
- **Ruby 3.2.2**
- **Rails 8.0.1**
- **PostgreSQL 16**

- **Geocoder:** For geolocation lookup services.

- **Hexagonal Architecture:** Focused on separating domain logic from external infrastructure (databases, geolocation services, etc.).

## Objectives
- Apply **hexagonal architecture** principles, using **ports** and **adapters** to decouple bussines logic from external dependencies.

- Learn how to integrate **geolocation** effectively, with a focus on scalability and maintainability.

## Setup
To get started with this project, you can use Docker to set up the application. Follow these steps:

1. **Build and start the application using Docker Compose:**

```
docker compose run --rm --service-ports app bash

```
2. **Run the application locally:**

```
bundle exec rails s -b 0.0.0.0
```

## Running Tests
To run tests for the application:

1. Run the setup script to prepare the environment:

```
bin/setup
```

2. Run the tests with RSpec:

```
bundle exec rspec
```

## Endpoints

### 1. `GET /locations/address`
Returns geographic coordinates based on a given address.

#### Query Parameters

| Parameter | Type            | Required | Description                        |
|-----------|-----------------|----------|------------------------------------|
| `street`  | string          | Yes      | Street name (e.g., Avenida Paulista) |
| `number`  | string/integer  | Yes      | Street number                      |
| `city`    | string          | No       | City name                          |
| `state`   | string          | Yes      | State or region                    |
| `country` | string          | Yes      | Country name (e.g., Brazil)        |

