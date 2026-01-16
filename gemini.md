# Gemini Project Instructions

## Project Title
Flutter Mobile App – API-Driven Skills Assessment (Mid-Level)

## Objective
Build a production-quality Flutter mobile application that demonstrates real-world mobile development skills, including API consumption, authentication flow, clean architecture, and state management.

This project is **practical-based** and should reflect how a real application would be structured, maintained, and scaled.

---

## Tech Stack (Mandatory)
- Flutter (latest stable)
- Dart
- REST API (public or mock)
- State Management: Provider
- Local storage: SharedPreferences or Secure Storage
- Git (GitHub)

---

## Core Functional Requirements

### 1. Authentication
- Implement a Login screen
- Accept **email** and **password**
- Validate inputs (non-empty, valid email format)
- Authenticate via:
  - Mock authentication logic **or**
  - Real API endpoint
- Persist login state locally
- Automatically restore session on app restart

---

### 2. Dashboard Screen
After successful login, display a dashboard containing:

#### User Profile Summary
- Name (mock allowed)
- Email
- Avatar (mock or placeholder allowed)

#### API-Fetched List
Display a list of items fetched from an API (e.g. posts, products, tasks, transactions).

Each list item must show:
- Title
- Short description
- Status or category
- Date (if applicable)

---

### 3. Details Screen
- Tapping an item opens a details page
- Display full item information
- Handle:
  - Loading states
  - Error states
  - Empty states

---

### 4. Create / Update Feature
- Screen for creating or updating an item
- Validate all inputs
- Show clear success and error feedback
- Reflect changes immediately on the dashboard

---

## Architecture & Code Quality

### Folder Structure (Required)
