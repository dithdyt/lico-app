# Lico App 📊

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-blue.svg?logo=dart)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State%20Management-Riverpod-blueviolet.svg)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Database-Isar-yellow.svg)](https://isar.dev)
[![Backend](https://img.shields.io/badge/Backend-Firebase-orange.svg?logo=firebase)](https://firebase.google.com)

**Lico** is a modern, high-performance financial management and valuation application built with Flutter. It helps users track ledger transactions, calculate financial valuations, manage accounts via Firebase Authentication, and visualize financial health using interactive charts and micro-animations.

---

## ✨ Key Features

*   **🔒 Secure Authentication**: Integrated with Firebase Authentication for seamless, secure user sign-in and sign-up flows.
*   **📝 Reactive Ledger & Tracker**: A local transaction journal that updates statistics and aggregates ledger records dynamically.
*   **🧮 Integrated Financial Calculator**: A handy, built-in calculator designed to perform quick financial math on the fly.
*   **📈 Advanced Valuation Engine**: Powerful valuation tools combined with responsive graphical representations of financial data.
*   **📊 Dynamic Visualizations**: Beautiful, interactive charts powered by `fl_chart` to track spending habits, earnings, and net worth.
*   **✨ Premium UI/UX**: Fluid micro-animations powered by `flutter_animate` paired with custom Google Fonts for a modern, sleek interface.

---

## 🛠️ Technology Stack

*   **Framework**: [Flutter](https://flutter.dev/) (Dart)
*   **State Management**: [Riverpod](https://riverpod.dev/) with code generation (`riverpod_generator`) for safe, robust, and testable state.
*   **Local Database**: [Isar Database](https://isar.dev/) — a lightning-fast NoSQL database optimized for mobile apps.
*   **Cloud Backend**: [Firebase Core](https://firebase.google.com/) & [Firebase Auth](https://firebase.google.com/docs/auth).
*   **Charts & Visualization**: [FL Chart](https://pub.dev/packages/fl_chart) for reactive graphs.
*   **Animation**: [Flutter Animate](https://pub.dev/packages/flutter_animate) for polished UX transitions.

---

## 📂 Project Structure

This project follows a **Feature-First** architecture pattern, grouping files by feature area rather than technical role. This ensures modularity, scalability, and ease of maintenance.

```text
lib/
├── core/                  # Core configurations, themes, constants, and utilities
└── features/              # Feature modules
    ├── auth/              # Authentication flows (Sign In, Sign Up, Profile)
    ├── calculator/        # Built-in financial calculator
    ├── ledger/            # Local ledger records and transaction tracking
    └── valuation/         # Valuation calculators and analytical dashboards
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed on your machine:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.11.0 or higher recommended)
*   [Dart SDK](https://dart.dev/get-started/sdk)
*   Android Studio / Xcode for running target platforms

### Installation & Setup

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/dithdyt/lico-app.git
    cd lico-app
    ```

2.  **Fetch Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run Code Generation**
    Generate Riverpod providers and Isar database schemas:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Configure Firebase**
    Setup your Firebase project and download `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) into their respective directories, or run the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/).

5.  **Run the Application**
    ```bash
    flutter run
    ```

---

## 🔧 Troubleshooting & Build Fixes

### Android Keyboard Input Crash Fix
If you encounter runtime crashes on Android release builds when clicking text input fields (`java.lang.NoSuchMethodError: No static method setStylusHandwritingEnabled`), the configuration in `android/build.gradle.kts` has been overridden to dynamically compile dependencies against SDK 34 while avoiding forced version downgrades.

### Generating a Release APK
To compile a production-ready APK for Android, run:
```bash
flutter build apk --release
```
The output APK will be saved to `build/app/outputs/flutter-apk/app-release.apk`.
