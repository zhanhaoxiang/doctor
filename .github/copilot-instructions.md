# Copilot Instructions

## Build, Test, and Lint Commands

- **Run App**: `flutter run`
- **Run Tests**: `flutter test` (Run specific file: `flutter test test/path/to/test.dart`)
- **Analyze Code**: `flutter analyze`
- **Format Code**: `dart format .`
- **Get Dependencies**: `flutter pub get`
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
  - `lib/data/models/`: Data models (fromJson/toJson).
  - `lib/data/providers/`: API clients (Dio/Http).
  - `lib/data/repositories/`: Repository implementation, extending `BaseRepository`.
- **Core Layer**: Shared resources in `lib/core/` (widgets, theme, utils, translations).
- **Services**: Global services (e.g., `LocaleService`, `StorageService`) in `lib/services/`.
- **Routing**: Centralized in `lib/routes/app_pages.dart` using `GetPage`.

### Data Flow
1.  **View** calls **Controller** method.
2.  **Controller** calls **Repository**.
3.  **Repository** calls **Provider** (API) or Local Storage.
4.  **Repository** returns **Model** to **Controller**.
5.  **Controller** updates reactive state (`.obs`).
6.  **View** updates via `Obx` or `GetBuilder`.

## Key Conventions

### Language
- **Comments & Documentation**: Write comments and documentation in **Chinese** (e.g., `// 统一处理接口响应`).

### State Management (GetX)
- Use `GetxController` for logic.
- Use `.obs` for reactive variables (e.g., `final count = 0.obs;`).
- Use `Obx(() => ...)` in the view to listen to changes.
- Use `Bindings` to inject controllers lazily via named routes.

### UI Development
- **CommonPage**: Use `CommonPage` (from `lib/core/widgets/common_page.dart`) as the root widget for new screens. It handles the `Scaffold`, `AppBar`, background color, and `CustomScrollView` setup.
- **Theming**: Use `AppTheme` and `AppColors` (from `lib/core/theme/`) for consistent styling. Avoid hardcoded colors/styles.
- **Responsiveness**: Use `flutter_screenutil` or GetX utilities if applicable (check usage), otherwise standard Flutter layout widgets.

### Service Initialization
- Initialize global services in `main.dart` using `Get.putAsync` inside `_initServices()`.
- Example: `await Get.putAsync(() async => LocaleService());`

### Networking
- Extend `BaseRepository` for repositories to use `handleResponse` for standardized error handling.
- Use `Dio` for HTTP requests.
