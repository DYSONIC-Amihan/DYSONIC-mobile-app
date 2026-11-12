# amihan_mobile

A new Flutter project.

## Before You Start Coding

Before creating or editing any code, run these two commands from the project root (the folder with `pubspec.yaml`):

```bash
git pull
flutter pub get
```

- `git pull` makes sure you have the latest changes from the team.
- `flutter pub get` installs the latest packages, so imports like `package:flutter/material.dart` and `package:shadcn_ui/shadcn_ui.dart` resolve correctly.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### FOLDER STRUCTURE

```
lib/
├── main.dart                          App entry: loads saved settings, ProviderScope, ShadApp theme, MaterialApp.router
├── core/                              Infrastructure shared by all features
│   ├── env.dart                       Build-time config (API URL, Google client ID) via --dart-define
│   ├── failure.dart                   Typed errors the UI can show (network, forbidden, etc.)
│   ├── api_client.dart                Dio client: base URL, timeouts, Bearer token, X-Client-Platform header
│   ├── api_guard.dart                 guardApi() runs an API call and turns any error into an Err; mapDioError() does the mapping
│   ├── token_storage.dart             Saves/reads/clears access and refresh tokens securely
│   ├── app_settings.dart              The user's settings model (dark/light mode and color palette)
│   └── util/
│       ├── result.dart                Success/Err wrapper so the UI never handles raw exceptions
│       └── validators.dart            Email, password, name, required and confirm-password rules
├── data/
│   ├── auth/
│   │   ├── auth_user.dart             UserRole, AuthUser, AuthSession models
│   │   ├── auth_repository.dart       The contract: sign in, sign up, Google, reset, sign out
│   │   ├── api_auth_repository.dart   Real backend implementation of the auth contract
│   │   ├── mock_auth_repository.dart  Fake backend for testing (emails starting "admin" become admins)
│   │   ├── mobile_access_policy.dart  The rule for which roles may use mobile (normal only)
│   │   └── guarded_auth_repository.dart  Wraps any repository and rejects admins after sign-in
│   ├── account/
│   │   ├── account_repository.dart    The contract: fetch profile, update name, list/update avatar, change password
│   │   ├── api_account_repository.dart   Real backend implementation of the account contract
│   │   ├── mock_account_repository.dart  Fake backend for testing
│   │   └── avatar_option.dart         Model for one selectable avatar
│   └── settings/
│       └── setting_storage.dart       Saves and loads settings on the device
├── providers/
│   ├── auth_providers.dart            Wires storage, API client and the auth repository (swap mock for API here)
│   ├── session_provider.dart          Holds the current signed-in session
│   ├── account_providers.dart         Wires the account repository
│   └── setting_provider.dart          Holds the current settings and saves changes
├── router/
│   ├── app_routes.dart                Route path constants
│   ├── app_router.dart                go_router setup with login/home redirect rules
│   └── nav_destinations.dart          The drawer menu entries (add a screen = add one entry here + a route)
├── services/
│   └── auth_services.dart             Google sign-in wrapper that returns an ID token for the backend
├── theme/
│   ├── app_palette.dart               Selectable color palettes, including the color-blind one
│   ├── app_theme.dart                 Builds the light and dark themes from the chosen palette
│   └── app_motion.dart                Shared animation durations and curves
├── widget/                            Base UI built on shadcn_ui
│   ├── app_button.dart                Button with variants and a loading state
│   ├── app_text_field.dart            Form text field
│   ├── app_password_field.dart        Password field with show/hide toggle
│   ├── sso_button.dart                "Continue with Google"-style button
│   ├── app_drawer.dart                Hamburger menu built from nav_destinations, with sign out
│   ├── app_section.dart               Titled group of content for settings-style screens
│   ├── confirm_dialog.dart            Reusable "Are you sure?" dialog (used for sign out)
│   ├── staggered_entrance.dart        Animates a list of items in one after another
│   └── user_avatar.dart               Round profile picture
└── screens/
    ├── auth/
    │   ├── controllers/
    │   │   ├── auth_form_controller.dart      Shared loading/error/success logic
    │   │   ├── login_controller.dart          Email login + Google
    │   │   ├── sign_up_controller.dart        Sign up + resend verification
    │   │   └── forgot_password_controller.dart
    │   ├── widgets/
    │   │   ├── auth_layout.dart               Centered, scrollable page shell
    │   │   ├── auth_card.dart                 Card with title, description, footer
    │   │   ├── auth_error_alert.dart          Red error banner
    │   │   └── or_divider.dart                "— or —" separator
    │   ├── login_screen.dart
    │   ├── sign_up_screen.dart
    │   ├── forgot_password_screen.dart
    │   └── index.dart                         Barrel file (exports the 3 screens)
    ├── account/
    │   ├── controllers/
    │   │   └── account_controllers.dart       Update name, change avatar and change password logic
    │   ├── widgets/
    │   │   ├── avatar_picker_sheet.dart       Bottom sheet for choosing an avatar
    │   │   └── edit_name_dialog.dart          Dialog for changing the display name
    │   ├── account_screen.dart                Profile header and account info
    │   └── change_password_screen.dart
    ├── settings/
    │   └── setting_screen.dart                Dark/light mode and color-blind mode
    └── home/
        └── home_screen.dart                   Placeholder home with the drawer
```

### Formatting of Files for clean code.

Run this command to clean your code and you won't be confused at reading them

```bash
dart format .
```