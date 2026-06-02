# RentKhata Coding Agent Guide

Welcome, Agent! This guide serves as onboarding context for building, modifying, or debugging the **RentKhata** codebase. Please read this file to understand the architecture, design system, and patterns of this project before starting your task.

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

## 🎨 Theme & Styling System

The application relies on a unified, high-contrast, modern visual palette that supports both light and dark themes.

### 1. App Colors
Defined in [app_colors.dart](file:///home/shanu/dev/active/rent-khata/lib/core/theme/app_colors.dart), the styling system consists of semantic palettes (`LightPalette`, `DarkBluePalette`, and `DarkGoldPalette`).

- **CRITICAL**: Do **NOT** use hardcoded legacy colors or static values directly. Always prefer theme-aware getters via the `BuildContext`:
  - `AppColors.primaryOf(context)`: Primary actions, CTAs, and key focus items.
  - `AppColors.secondaryOf(context)`: Accents, secondary containers, and highlights.
  - `AppColors.surfaceOf(context)`: Cards, list tiles, and dialog backgrounds.
  - `AppColors.onSurfaceOf(context)`: Main text and icons overlaying surfaces.
  - `AppColors.outlineOf(context)`: Borders, dividers, and outlines.
  - `AppColors.paletteOf(context)`: Complete palette access (headings, border, background).

### 2. Semantic & Financial Color Coding
Ensure that colors conveying information align with these constants:
- **Success/Money Received**: `AppColors.success` / `AppColors.moneyReceived` (green)
- **Warning/Money Pending**: `AppColors.warning` / `AppColors.moneyPending` (yellow)
- **Error/Money Overdue**: `AppColors.error` / `AppColors.moneyOverdue` (red)
- **Information**: `AppColors.info` (blue)

### 3. Screen Layout & Overflow Prevention
To ensure UI elements scale gracefully across smaller devices, foldable screens, or when the system keyboard/view insets are open:
- Always wrap vertical scrolling layouts inside a `SingleChildScrollView`.
- When utilizing a `Column` inside a scrollable layout or bottom sheet, set its `mainAxisSize` to `MainAxisSize.min` so it occupies only its required natural space.
- Keep margins and padding consistent with standard layouts (typically `16.0` or `24.0` spacing).

---

## 🔑 Core Technical Concepts

### 1. Database & Code Generation
- The database schema is defined in `lib/data/database/app_database.dart` and table directories under `lib/data/database/tables/`.
- If you modify any tables, models, or Riverpod providers, you **MUST** regenerate the generated files using:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

### 2. Navigation & Safe Contexts
- In RentKhata, invalidating active Riverpod providers during route changes (e.g., when adding a tenant or generating a bill) causes GoRouter to rebuild the route tree. This can instantly unmount the local screen's `BuildContext`.
- **Crucial Rule**: To safely trigger global sheets, dialogs, or navigations *after* asynchronous state mutation, do **not** rely solely on `context.mounted`. Instead, resolve and use the global navigation context:
  ```dart
  import 'package:rent_khata/presentation/router/app_router.dart';
  
  final safeContext = rootNavigatorKey.currentContext;
  if (safeContext == null || !safeContext.mounted) return;
  
  // Show sheets or trigger dialogs using safeContext
  ```

### 3. Localization (l10n)
- **Do not hardcode user-facing strings** (including Toast/Snackbar notices or Alert titles).
- Append new string templates to `lib/l10n/app_en.arb` (English) and `lib/l10n/app_hi.arb` (Hindi), then compile the code or run:
  ```bash
  flutter gen-l10n
  ```
- Access localized strings in code via `AppLocalizations.of(context)!.yourStringKey`.
