# RentKhata Coding Agent Guide

Welcome, Agent! This guide serves as onboarding context for building, modifying, or debugging the **RentKhata** codebase. Please read this file to understand the architecture, patterns, and guidelines of this project.

---

## 📱 Project Overview

**RentKhata** is an offline-first rental management application tailored for Indian landlords. It allows them to track properties, manage rooms, record tenants/occupancies, generate rent bills, configure custom anniversary billing cycles, schedule smart reminders (due, overdue, deposit settlement), and secure the application with a biometric App Lock.

---

## 🛠️ Tech Stack & Architecture

- **Language**: Dart / Flutter (targeting Android and iOS).
- **Architecture**: Domain-Driven Design (DDD) split into:
  - `domain`: Contains entities and repository interfaces.
  - `data`: Implements database schemas, DAOs, and repository concrete implementations.
  - `application`: Holds Riverpod providers and application logic.
  - `presentation`: UI screens, sheets, widgets, and router configurations.
- **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod) using code generation (`@riverpod` annotations, `riverpod_generator`).
- **Database**: [Drift](https://pub.dev/packages/drift) (SQLite wrapper) for local reactive database storage.
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router) with paths declared in `lib/presentation/router/app_router.dart`.
- **Localization**: Standard Flutter `l10n` tool (`l10n.yaml`) with templates in `lib/l10n/app_en.arb` and `lib/l10n/app_hi.arb`.
- **Animations**: `flutter_animate` for premium fluid UI transitions.

---

## 🔑 Core Components & Concepts

### 1. Database & Code Generation
- The database schema is defined in `lib/data/database/app_database.dart` and table directories under `lib/data/database/tables/`.
- If you modify any tables, models, or Riverpod providers, you **MUST** regenerate the generated files using:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

### 2. Custom Navigation & Safe Contexts
- In RentKhata, invalidating active Riverpod providers during route changes (e.g., when adding a tenant or generating a bill) causes GoRouter to rebuild the route tree. This can instantly unmount the local screen's `BuildContext`.
- **Crucial Rule**: To safely trigger global sheets, dialogs, or navigations *after* asynchronous state mutation, do **not** rely solely on `context.mounted`. Instead, resolve and use the global navigation context:
  ```dart
  import 'package:rent_khata/presentation/router/app_router.dart';
  
  final safeContext = rootNavigatorKey.currentContext;
  if (safeContext == null || !safeContext.mounted) return;
  
  // Show sheets or trigger notifications using safeContext
  ```

### 3. Permissions & Recovery Flows
- **Biometric Security**: Handled by `BiometricService` (`local_auth`). 
  - Before enabling the biometric App Lock in settings, you **must** authenticate the user first to verify screen lock configurations exist and function.
- **Notifications**: Reminders are scheduled locally using `FlutterLocalNotificationsPlugin` and time zones.
  - If notification permissions are disabled at the system level, the settings UI renders a localized warning banner linking directly to OS settings via a custom MethodChannel `com.rentkhata.rent_khata/settings` (defined in `MainActivity.kt`).

### 4. Localization (l10n)
- **Do not hardcode user-facing strings** (including Toast/Snackbar notices or Alert titles).
- Append new string templates to `lib/l10n/app_en.arb` (English) and `lib/l10n/app_hi.arb` (Hindi), then compile the code or run:
  ```bash
  flutter gen-l10n
  ```
- Access localized strings in code via `AppLocalizations.of(context)!.yourStringKey`.

---

## 🎨 Styling Guidelines

RentKhata values premium visual design and micro-animations:
- **Borders & Corners**: Dialogs and sheets use smooth curves (like a border-radius of `32` for sheets).
- **Colors**: Avoid using pure primaries (like plain red/blue). Instead, use theme palettes (e.g., HSL tailored colors, transparent primary containers like `theme.colorScheme.primaryContainer.withValues(alpha: 0.5)`).
- **Scrolls**: Always wrap layouts susceptible to overflow on small/scaled screens inside `SingleChildScrollView` with `mainAxisSize: MainAxisSize.min` on children `Column`s.
