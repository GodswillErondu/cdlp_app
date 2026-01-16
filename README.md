# cdlp_app


A new Flutter project.


This design system is a comprehensive architectural and engineering blueprint derived from your strategic analysis. It prioritizes **maintainability, security, and scalability** for mid-level Flutter applications.

---

## 1. Core Architectural Philosophy

The system is built on the **Separation of Concerns (SoC)**. It moves beyond "making it work" to "making it resilient" by isolating the UI from business logic and data acquisition.

### Standard Directory Structure (`lib/`)

| Directory | Responsibility | Key Components |
| --- | --- | --- |
| `models/` | Data structures & serialization | DTOs, Entities, Mappers |
| `services/` | External communication | API Clients (Dio), DB Helpers |
| `providers/` | State management & business logic | AsyncNotifiers, Blocs, States |
| `screens/` | High-level UI containers | Feature Pages, Layout Shells |
| `widgets/` | Atomic, reusable UI elements | Custom Buttons, List Cards |

---

## 2. Data & Networking Layer

To ensure the app survives backend volatility, the system mandates a distinction between **Data Transfer Objects (DTOs)** and **Domain Entities**.

* **Serialization:** Use automated tools (`freezed` or `json_serializable`) to eliminate manual parsing errors.
* **Networking Client:** Use `Dio` with **Interceptors** to automatically inject JWTs into headers.
* **Resiliency Rule:** Domain Entities must account for **nullability** to prevent rendering crashes ("Grey Screen of Death").

---

## 3. Security & Persistence Standards

The system categorizes data storage based on sensitivity to ensure hardware-level protection.

### Storage Selection Matrix

* **Sensitive Data (JWTs, PII):** Use `flutter_secure_storage` (iOS Keychain / Android KeyStore).
* **User Preferences (Themes, Language):** Use `SharedPreferences` (Plain text).

### Authentication Workflow

1. **Validation:** Enforce client-side regex (Email/Password) before triggering API calls.
2. **Encryption:** All transmission must occur over **TLS 1.3**.
3. **Session Management:** Implement "Auto-login" by checking for stored tokens during the app's initialization phase.

---

## 4. State Management Patterns

The system supports two primary industry-standard patterns. Both must handle the **Loading → Data → Error** lifecycle.

### Pattern A: Riverpod (AsyncNotifier)

* **Loading:** Show `CircularProgressIndicator`.
* **Data:** Render the primary content.
* **Error:** Show a user-friendly message with a **Retry Button**.

### Pattern B: BLoC (Event-Driven)

* Strictly separate interactions (Events) from UI updates (States).
* Recommended for enterprise-scale features requiring high testability.

---

## 5. UI & Component Library

The UI system focuses on visual continuity and performance optimization.

### Atomic Components

* **Cards:** Use `maxLines` and `TextOverflow.ellipsis` for descriptions to maintain grid symmetry.
* **Formatting:** Use the `intl` package for all date/currency strings to ensure localization readiness.
* **Animations:** Use **Hero Widgets** with unique ID tags for transitions between Dashboard and Detail screens.

### Performance Rules

* **Const Constructors:** Mandatory for all static widgets to optimize the build tree.
* **Memory Efficiency:** Use `ListView.builder` for all dynamic lists.
* **Logic Isolation:** No complex transformations inside the `build()` method.

---

## 6. Quality Assurance & Delivery

A project is not complete until it is verified and documented.

### Testing Requirements

* **Unit Tests:** Mock API responses using `mockito` to test repository failure/success states.
* **Widget Tests:** Verify UI behavior (e.g., ensuring a button is disabled when a form is invalid).

### Submission Standards

* **GitHub:** Clean commit history, `.gitignore` included, feature branching.
* **README:** Must include Setup Instructions, Architectural Context, and High-Quality Screenshots.
* **Distribution:** Provide a **Release APK** (not debug) for performance evaluation.



Product Requirements Document (PRD): Resilient Flutter Dashboard1. Executive SummaryThe goal is to build a production-grade, API-driven Flutter application within a 48-hour window. The app must demonstrate mid-level engineering proficiency through secure authentication, efficient data fetching, and a scalable architecture that separates business logic from the presentation layer.2. Target Audience & ObjectivePrimary Users: Mobile users requiring authenticated access to product/data catalogs.

Engineering Objective: Demonstrate "resilient" coding practices, including centralized error handling, hardware-level security, and optimized UI rendering.3. Functional Requirements3.1 Authentication & SecuritySecure Login: A form requiring email and password with real-time validation.Token Management: Successful login must return a JWT. This token must be stored using flutter_secure_storage.Session Persistence: On app launch, the system must check for an existing token to bypass the login screen (Auto-login).Log-out: A mechanism to clear the secure storage and return the user to the Login screen.3.2 The Dashboard (Data Visualization)Profile Summary: Display user data (name, email, avatar) at the top of the dashboard.Asynchronous List: Fetch a list of items (e.g., products) from a REST API.State Feedback: The UI must explicitly show:A shimmer or spinner during Loading.A formatted list upon Success.A "Retry" button and error message upon Failure.3.3 CRUD Operations (Data Mutation)Create/Edit Form: A unified form to add new items or update existing ones.Optimistic UI/State Updates: After a successful API POST or PUT, the dashboard list must update immediately without a full page reload.Getty Images4. Technical Specifications (Non-Functional)4.1 Architecture & State ManagementPattern: Clean Architecture (Separation of UI, Domain, and Data).State Provider: Riverpod (AsyncNotifier) or BLoC.Networking: Dio package with Interceptors for automated Bearer Token injection.4.2 UI/UX StandardsResponsiveness: Use ListView.builder for memory-efficient scrolling.Consistency: Implementation of a global ThemeData (Light/Dark).Transitions: Use Hero Animations for shared elements between the Dashboard and Detail screens.4.3 Reliability & PerformanceError Handling: A centralized repository-level mapper that converts HTTP status codes (404, 500, etc.) into human-readable strings.Formatting: All dates must be localized using the intl package.5. User Journey MapStepUser ActionSystem Response1Opens AppChecks Secure Storage for JWT. Navigates to Dashboard or Login.2Enters CredentialsValidates format; sends POST request; stores token; navigates.3Views DashboardTriggers GET request; shows loading state; renders list.4Taps ItemTriggers Hero animation; navigates to Detail view.5Updates ItemValidates form; sends PUT request; updates local state; pops back.6. Project Success Metrics (The "Mid-Level" Bar)Zero "Grey Screens": Comprehensive null-safety in data models.Code Coverage: Unit tests for the Repository and Service layers.Documentation: A README.md that allows a new developer to run the project in under 5 minutes.7. Bonus Features (Priority 2)Offline Caching: Use Hive to store the last successful API response for offline viewing.Theme Persistence: Allow users to toggle Dark Mode and save the preference in SharedPreferences.Pagination: Implement "Infinite Scroll" for the dashboard list to handle large datasets.


