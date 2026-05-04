# Sprint 3 Detail Plan: User Management

## Goal
Implement a searchable user directory and the main application shell (Home) while maintaining a strict layered architecture and centralized logic.

## 1. Preparation Phase (Current)
- [ ] Add localization keys to `ar.json` and `en.json`.
- [ ] Register `HomeScreen` and `UsersScreen` in `AppRoutes.dart`.

## 2. Data Layer (Service)
- [ ] Create `UserService` in `lib/features/user/data/`.
- [ ] Implement `getAllUsers()` returning `Stream<List<UserModel>>`.
- [ ] Implement server-side/client-side search logic.

## 3. Provider Layer (State Management)
- [ ] Create `UserProvider` in `lib/features/user/provider/`.
- [ ] Handle `UserService` streams and search state.
- [ ] Integrate with `NavigationService` for user selection.
- [ ] Register `UserProvider` in `main.dart`.

## 4. Presentation Layer (UI)
- [ ] Build `HomeScreen` (BottomNav shell).
- [ ] Build `UsersScreen` (Search + User List).
    - Reuse `CustomTextField`.
    - Implement `UserTile` with online status indicator.
- [ ] Link `SplashScreen` to `HomeScreen` for authenticated users.

## 5. Verification
- [ ] Verify search filtering.
- [ ] Verify "No Users Found" state.
- [ ] Verify RTL support on Users list.
- [ ] Test Session persistence redirecting to Home.
