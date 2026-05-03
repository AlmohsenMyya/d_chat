# Recommendations & Reusability Guide: Transitioning to Sprint 3

As we prepare for **Sprint 3 (User Management)**, this guide ensures we build upon the solid foundation established in Sprint 2 without reinventing the wheel.

---

## 1. Key Architectural Recommendations

### A. Maintain "Dumb UI"
*   **Rule**: Never add logic like `FirebaseFirestore.instance` or `Navigator.of(context)` inside a screen widget.
*   **Action**: All Firestore fetching for Sprint 3 (Users list) must happen in a new `UserProvider`, which calls a `UserService`.

### B. Leverage `NavigationService`
*   When a user selects another user to chat with, the `UserProvider` should call `_navigationService.navigateTo(AppRoutes.chat, arguments: selectedUser)`.

### C. Standardized Error Handling
*   Follow the pattern used in `AuthProvider`: Map technical Firestore/Firebase errors to translation keys in the `Provider` layer, and let the UI simply display them.

---

## 2. Reusable Components (Do Not Re-create)

### UI Widgets (`lib/shared/widgets/`)
*   **`CustomTextField`**: Use this for the User Search bar in Sprint 3. It already supports icons and the Royal Blue identity.
*   **`AppThemes`**: Always wrap new screens in the established theme to maintain the 20px rounded corner look.

### Services (`lib/core/utils/` & `lib/features/auth/data/`)
*   **`NavigationService`**: Already globally available. Use it for all transitions.
*   **`AppLocalizations`**: Ensure every new string (e.g., "Search Users", "No Users Found") is added to `ar.json` and `en.json` first.

### Models (`lib/features/user/data/`)
*   **`UserModel`**: This is already fully implemented. Use it to map the stream of users from Firestore to the UI list.

---

## 3. Sprint 3 Implementation Strategy (Proposed)

1.  **Phase 1: Data Layer**: Create `UserService` to fetch all users except the current one.
2.  **Phase 2: State Layer**: Create `UserProvider` to manage the list state, search filters, and loading indicators.
3.  **Phase 3: Presentation**:
    *   Implement **Home Screen** (Screen 7) as a shell with Bottom Navigation.
    *   Implement **Users Screen** (Screen 8) with a searchable list using the `UserModel`.
4.  **Phase 4: Linking**: Connect the `SplashScreen` to go to `Home` if authenticated.

---
**Ready to scale. Sprint 3 awaits!**
