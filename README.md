# 🎉 Job Finder

A modern **Flutter** mobile application that helps users find job opportunities based on their skills and preferences. Built with Clean Architecture, a custom Design System, and Supabase as the backend.

## Screenshots

[![Product Name Screen Shot][product-screenshot]]()

## Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter (Dart SDK `^3.10.7`) |
| **State Management** | `ChangeNotifier` + `ListenableBuilder` |
| **Routing** | `go_router` with auth redirect logic |
| **Backend** | Supabase (Auth, Database, Storage) |
| **Error Handling** | Railway-Oriented Programming (`fpdart` — `Either<Failure, T>`) |
| **Design System** | Two local packages (`job_design_system` + `job_design_tokens`) |
| **i18n** | `easy_localization` (`en`, `es`, `it`) |
| **Theme** | Material 3 with Light/Dark mode support |
| **Font** | Inter (Regular, Medium, SemiBold, Bold) |

## Architecture

Feature-based + Clean Architecture with MVVM pattern:

```
lib/src/features/<feature>/
├── data/           ← How data is obtained
│   ├── datasources/    → Supabase calls
│   ├── models/         → DTOs (JSON ↔ Dart)
│   └── repositories/  → Concrete implementations
├── domain/         ← What data exists (business rules)
│   ├── entities/       → Pure models
│   └── repositories/  → Abstract contracts
└── presentation/   ← How data is displayed
    ├── controllers/    → ViewModels (ChangeNotifier)
    └── screens/        → Screen widgets
```

### Data Flow

```
Screen → ViewModel → Repository Interface → Repository Impl → Datasource → Supabase
                                                                    ↓
                                              Model/DTO → maps to → Entity → ViewModel → UI
```

## Features

| Feature | Status | Description |
|---------|--------|-------------|
| **Onboarding** | ✅ | 3-step introduction carousel |
| **Auth** | ✅ | Login, Register, Forgot Password, OTP verification |
| **Account Setup** | ✅ | 4-step profile setup (country, expertises, accounts, avatar) |
| **Home** | 🔄 | Hot Vacancies, Best Matches (with filters), Most Recent jobs |
| **Search** | 🏗️ | Job search with filters |
| **Interviews** | 🏗️ | Interview tracking |
| **Inbox** | 🏗️ | Messages |
| **Account** | 🏗️ | Profile settings |

> ✅ Complete · 🔄 In Progress · 🏗️ Planned

## Project Structure

```
lib/
├── main.dart                  → App entry point (Supabase init, splash, i18n)
└── src/
    ├── app.dart               → MaterialApp.router (theme, routing, localization)
    ├── features/              → Feature modules
    │   ├── auth/              → Login, Register, Forgot Password, OTP
    │   ├── home/              → Home screen (Hot Vacancies, Best Matches, Most Recent)
    │   ├── onboarding/        → Onboarding carousel
    │   ├── setup/             → Account setup wizard (4 steps)
    │   ├── search/            → Job search (planned)
    │   ├── interviews/        → Interview tracking (planned)
    │   ├── inbox/             → Messages (planned)
    │   └── account/           → Profile settings (planned)
    ├── routing/               → GoRouter config, routes, auth redirect
    ├── shared/                → Helpers, reusable widgets, wrappers
    ├── imports/               → Barrel exports (single import per file)
    └── utils/                 → Transitions, validators, Failure types, typedefs

packages/
├── job_design_system/         → DS components (DSJobCard, DSFilterChip, etc.)
└── job_design_tokens/         → Tokens (colors, spacing, radius, typography)
```

## Design System

Two local packages power the UI:

- **`job_design_tokens`** — Primitive and semantic tokens accessed via context extensions:
  - `context.dsColors.primary`, `context.dsTextTheme.bodyLarge`
  - `SpacingTokens.spacing24`, `SizesTokens.size48`, `RadiusTokens.md`

- **`job_design_system`** — Reusable components prefixed with `DS`:
  - `DSJobCard`, `DSFilterChip`, `DSSearchBar`, `DSSectionHeader`, `DSHotVacancyCard`, `DSRecentJobCard`, `DSCircularIcon`

## Database Setup (Supabase)

This project uses Supabase for the backend. The complete database schema, RLS policies, seed data, and query examples are documented in **[DATABASE.md](DATABASE.md)**.

Run the SQL scripts **in order** in your Supabase SQL Editor:

1. **`profiles`** table + RLS policies
2. **Auto-create profile** trigger on user signup
3. **`avatars`** Storage bucket + RLS policies
4. **`companies`** table + RLS policies
5. **`job_listings`** table + indexes + RLS policies
6. **`companies_with_open_jobs`** VIEW
7. **Seed data** (sample companies and job listings)

## Environment Variables

Create a `.env` file in the project root (see `.env.example`):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

## Getting started

```bash
# Install dependencies
flutter pub get

# iOS only — install pods
cd ios && pod install && cd ..

# Run the app
flutter run
```

For detailed setup instructions (native splash, permissions, .env config), see **[SETUP.md](SETUP.md)**.

## Key Patterns

| Pattern | Usage |
|---------|-------|
| **MVVM** | ViewModels with `ChangeNotifier` + `ListenableBuilder` |
| **Repository** | Abstract in `domain/` + implementation in `data/` |
| **Barrel Exports** | Single import per file via `imports/imports.dart` |
| **Railway-Oriented** | `FutureEither<T>` with `fpdart` for error handling |
| **State Enum** | `enum XState { loading, loaded, error }` + `switch` expression |
| **Design Tokens** | Primitive → semantic token separation |

## Code Quality

- **Strict TypeScript-equivalent**: `strict-inference`, `implicit-dynamic: false`
- **40+ lint rules** enforced via `analysis_options.yaml`
- **No `dynamic`/`any`** unless justified with a comment
- **`const` constructors** and `final` locals preferred
- **Conventional Commits**: `feat(scope):`, `fix(scope):`, `refactor(scope):`

## License

This project is for educational purposes.


<!-- MARKDOWN LINKS & IMAGES -->
[product-screenshot]: assets/images/screenshots.png