# Project Structure & Architecture

This project follows a **Feature-first** architecture combined with principles from **Clean Architecture**.

## Directory Structure

```
lib/
├── core/                 # Shared resources, utilities, and configuration
│   ├── constants/        # App-wide constants
│   ├── theme/            # Theme definitions
│   ├── utils/            # Helper functions
│   ├── widgets/          # Common UI components
│   ├── router/           # Navigation setup
│   └── network/          # Network client setup (Dio)
├── features/             # Business features (e.g., auth, home, profile)
│   └── [feature_name]/
│       ├── data/         # API calls, DTOs, Repositories
│       ├── domain/       # Entities, Business Logic
│       └── presentation/ # UI (Screens, Widgets) & State
└── main.dart             # App Entry point
```

## Design Principles

1.  **Separation of Concerns**: Each feature manages its own responsibilities.
2.  **Scalability**: New features can be added without modifying existing core logic.
3.  **Maintainability**: Core utilities and themes are centralized.
