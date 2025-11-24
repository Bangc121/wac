# Project Structure & Architecture

This project follows a **Feature-first** architecture combined with principles from **Clean Architecture**. This approach ensures scalability, maintainability, and ease of testing.

## 🏗 Directory Structure

The `lib/` directory is divided into two main sections: **Core** and **Features**.

```
lib/
├── core/                 # Shared resources, utilities, and configuration
│   ├── constants/        # App-wide constants (API keys, endpoints, static strings)
│   ├── network/          # Network configuration (Dio setup, Interceptors)
│   ├── router/           # Navigation setup (GoRouter configuration)
│   ├── theme/            # App styling (ThemeData, Colors, TextStyles)
│   ├── utils/            # Helper functions, formatters, and extensions
│   └── widgets/          # Reusable generic widgets (Buttons, Inputs, Loaders)
│
├── features/             # Business features (e.g., auth, home, profile)
│   └── [feature_name]/   # Self-contained module for a specific feature
│       ├── data/         # Data Layer: API calls, DTOs, Repositories Implementation
│       ├── domain/       # Domain Layer: Entities, Use Cases, Repository Interfaces
│       └── presentation/ # UI Layer: Screens, Widgets, State Management (Providers)
│
└── main.dart             # App Entry point (ProviderScope, App Setup)
```

## 📐 Key Architectural Components

### 1. State Management: [Riverpod](https://riverpod.dev)
- We use **Riverpod** for dependency injection and state management.
- The `ProviderScope` is initialized in `main.dart`.
- Providers should be defined close to where they are used (e.g., inside `features/[name]/presentation/providers`).

### 2. Navigation: [GoRouter](https://pub.dev/packages/go_router)
- Routing is handled by **GoRouter** configured in `lib/core/router/app_router.dart`.
- It supports deep linking and nested navigation.
- The router is exposed via a Riverpod provider to allow redirection based on app state (e.g., auth status).

### 3. Networking: [Dio](https://pub.dev/packages/dio)
- API calls are handled by **Dio**.
- A global `dioProvider` is configured in `lib/core/network/dio_provider.dart`.
- This includes default timeouts, base URLs, and interceptors (logging, auth).

### 4. Data Modeling: [Freezed](https://pub.dev/packages/freezed)
- We use **Freezed** and **JsonSerializable** to generate immutable data classes and handle JSON serialization/deserialization automatically.

## 🚀 Design Principles

1.  **Separation of Concerns**: Each feature manages its own responsibilities. The UI should not know about API implementation details.
2.  **Scalability**: New features can be added as new folders under `features/` without modifying existing core logic.
3.  **Maintainability**: Core utilities and themes are centralized in `lib/core`. Changes here propagate app-wide.
