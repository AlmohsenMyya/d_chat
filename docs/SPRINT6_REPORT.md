# Sprint 6 Completion Report: Personalization & Global Settings

This report details the implementation of user profile management and application-wide settings.

---

## 1. Profile Management
- **Implementation**:
    - Created `ProfileProvider` to handle profile update logic.
    - Integrated `MediaService` for picking profile images.
    - Added `updateUserProfile` to `UserService` to sync changes to Firestore.
    - Built `ProfileScreen` allowing users to change their name and profile photo.
- **Results**: Users can now personalize their accounts, and changes are reflected globally in the app.

## 2. Global Settings
- **Implementation**:
    - Built `SettingsScreen` as a centralized hub for app configuration.
    - Linked `ThemeProvider` for manual Dark Mode switching.
    - Linked `LanguageProvider` for dynamic English/Arabic language switching.
- **Results**: The app now supports full user control over appearance and localization.

## 3. Navigation & UX
- **Implementation**:
    - Added a `Drawer` to the `HomeScreen` for easy access to Profile, Settings, and Logout.
    - Updated `AppRoutes` to include the new screens with proper provider injection.
- **Results**: Navigation is more intuitive and follows standard mobile app patterns.

---

## Technical Summary
- **Architecture**: Strict adherence to the layered architecture (UI -> Provider -> Service).
- **Dependency Injection**: Used `ChangeNotifierProvider` and `context.read/watch` for clean dependency management.
- **Security**: All profile updates are performed using the authenticated user's UID.

**Sprint 6 is officially complete and verified.**
