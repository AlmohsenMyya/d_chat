# Sprint 6 Implementation Plan: Personalization & Global Settings

## 1. Goal
Empower users to personalize their experience through profile management and global application settings (Theme & Language).

---

## 2. Scope & Features

### A. Profile Management
- **View Profile**: Display current user info (Photo, Name, Email).
- **Edit Name**: Update display name in Firebase Auth and Firestore.
- **Update Profile Image**: Change profile photo (Upload to Cloudinary, update Firestore).
- **Account Info**: Display read-only account metadata (Member since).

### B. Global Settings
- **Theme Toggle**: Manually switch between Light and Dark mode.
- **Language Switcher**: Toggle between Arabic (RTL) and English (LTR).
- **Notification Settings**: Toggle for push notifications (Enable/Disable FCM logic).
- **About App**: Version info and app description.

---

## 3. Technical Strategy

### Layered Implementation:
1. **Data Layer**:
    - Extend `UserService` to include `updateUserProfile(String name, String? photoUrl)`.
    - Utilize `MediaService` for image picking.
2. **Provider Layer**:
    - **ProfileProvider**: Manage loading states for profile updates.
    - **SettingsProvider**: Existing (Theme/Language Providers) will be linked to the new UI.
3. **Presentation Layer**:
    - `ProfileScreen`: Large avatar, edit icon, save button.
    - `SettingsScreen`: List of options with toggles and dropdowns.
    - `AppRoutes`: Register routes for `/profile` and `/settings`.

---

## 4. Tasks & Estimation

| Task ID | Description | Complexity |
| :--- | :--- | :--- |
| S6.1 | Create `ProfileScreen` UI & logic | Medium |
| S6.2 | Implement `updateUserProfile` in `UserService` | Low |
| S6.3 | Create `SettingsScreen` UI | Low |
| S6.4 | Integrate `LanguageProvider` & `ThemeProvider` into Settings | Medium |
| S6.5 | Link Profile & Settings in `HomeScreen` Drawer/Navigation | Low |
| S6.6 | Add "Delete Account" / "Sign Out" options for completeness | Low |

---

## 5. Definition of Done
- Users can change their name and photo successfully.
- Theme and Language changes persist across app restarts.
- UI follows the Royal Blue (#1A73E8) theme with 20+ radius corners.
- Code passes `flutter analyze` with 0 errors.

---
**Status: Draft. Waiting for final review.**
