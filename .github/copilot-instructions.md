# Copilot Instructions

## Build, Test, and Lint Commands

- **Run App**: `flutter run`
- **Run Tests**: `flutter test` (single file: `flutter test test/path/to/test.dart`)
- **Analyze Code**: `flutter analyze`
- **Format Code**: `dart format .`
- **Get Dependencies**: `flutter pub get`
- **Regenerate Drift code** (required after changing DB table definitions): `flutter pub run build_runner build --delete-conflicting-outputs`
- **Clean Project**: `flutter clean`

## High-Level Architecture

### Framework
- **Flutter** with **GetX** for state management, dependency injection, and routing.

### Structure
- **Feature-First Organization**: Located in `lib/pages/<feature_name>/`.
  - Each feature typically includes:
    - `view`: The UI file (e.g., `home_page.dart`).
    - `controller`: Business logic and state (e.g., `home_controller.dart`).
    - `binding`: Dependency injection setup (e.g., `home_binding.dart`).
- **Data Layer**:
  - `lib/data/local/app_database.dart` — Drift (SQLite ORM) table definitions. `app_database.g.dart` is code-generated; never edit it manually.
  - `lib/data/models/` — Hand-written domain models mapped from Drift query results (not JSON-based).
  - `lib/data/repositories/local_data_repository.dart` — The single data access point; extends `GetxService`. Uses Drift `.watch()` streams for reactive queries.
  - `lib/data/providers/api_provider.dart` — HTTP client (Dio) used only for external AI/OCR services.
- **Core Layer**: Shared resources in `lib/core/` (widgets, theme, utils, translations).
- **Services**: Global singletons in `lib/services/` (e.g., `LocaleService`).
- **Routing**: Centralized in `lib/routes/app_pages.dart` using `GetPage`.

### Navigation / Tab Structure
`MainPage` (`lib/pages/main/`) is the root scaffold. It uses an `IndexedStack` to preserve state across 4 tabs (Home, Reminders, Search, Settings) and a custom `BottomDock` widget for tab switching. Tab pages build their own `Scaffold` independently — they do **not** use `CommonPage`.

### Data Flow
1. **View** calls **Controller** method.
2. **Controller** calls `LocalDataRepository`.
3. Repository executes a Drift query (stream for live data, future for one-shots).
4. **Controller** updates reactive state (`.obs`).
5. **View** re-renders via `Obx`.

## Key Conventions

### Language
- **Comments & documentation**: Write in **Chinese** (e.g., `// 统一处理接口响应`).

### State Management (GetX)
- Use `GetxController` for logic.
- Use `.obs` for reactive variables (e.g., `final count = 0.obs;`).
- Use `Obx(() => ...)` in the view to observe changes.
- Use `Bindings` to inject controllers lazily via named routes.

### UI Development
- **CommonPage** (`lib/core/widgets/common_page.dart`): Use as the root widget for **inner/detail screens** (non-tab pages). It provides `Scaffold` + a centered title top bar with back button + `CustomScrollView` with `BouncingScrollPhysics`. Pass content via its `slivers:` list.
- **Top bar pattern for tab pages**: Manually build a `Column` with a `Container` (colored `AppColors.bg`, padded by `MediaQuery.of(context).padding.top`) holding a `Padding(fromLTRB(16,10,16,8))` row of `_IconBtn` / leading widget / title / trailing widget. See `home_page.dart` or `search_page.dart` for reference.
- **`_IconBtn` pattern**: A 32×32 white rounded container (`borderRadius: 10`, `border: AppColors.line`) wrapping a `GestureDetector`. Repeated across many pages — copy this local widget pattern rather than creating a shared one.
- **Theming**: Use `AppColors` for all colors (never hardcode). Key tokens: `AppColors.bg` (page background), `AppColors.card` (white), `AppColors.ink1/2/3` (text hierarchy), `AppColors.accent` (green), `AppColors.accentLight` (green tint), `AppColors.line` (dividers/borders).

### Database (Drift)
- Table definitions live in `app_database.dart` as plain Dart classes extending `Table`.
- After any schema change, run `build_runner` to regenerate `app_database.g.dart`.
- All database access goes through `LocalDataRepository` — never access `AppDatabase` directly from a controller.
- Use `.watch()` streams for data that needs to stay in sync with the UI; use `.get()` / `Future` for one-time reads.

### Service Initialization
- Initialize global services in `main.dart` via `Get.putAsync` inside `_initServices()`.
- Example: `await Get.putAsync(() async => LocaleService());`
