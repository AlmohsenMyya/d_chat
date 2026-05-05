import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:d_chat/main.dart';
import 'package:d_chat/core/theme/theme_provider.dart';
import 'package:d_chat/core/localization/language_provider.dart';
import 'package:d_chat/core/utils/navigation_service.dart';
import 'package:d_chat/features/auth/provider/auth_provider.dart';
import 'package:d_chat/features/auth/data/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class FakeAuthService implements AuthService {
  @override
  Stream<User?> get authStateChanges => Stream.value(null);
  @override
  User? get currentUser => null;
  @override
  Future<UserCredential> signIn(String email, String password) => throw UnimplementedError();
  @override
  Future<UserCredential> signUp(String email, String password, String name, {File? imageFile}) => throw UnimplementedError();
  @override
  Future<void> updateFCMToken(String uid, String? token) => Future.value();
  @override
  Future<void> signOut() => Future.value();
  @override
  Future<String?> uploadProfileImage(File imageFile) => Future.value(null);
}

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    final fakeAuthService = FakeAuthService();
    final navService = NavigationService();
    final languageProvider = LanguageProvider();
    languageProvider.setLocale(const Locale('ar')); // Set to Arabic for test
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NavigationService>.value(value: navService),
          Provider<AuthService>.value(value: fakeAuthService),
          ChangeNotifierProvider(create: (_) => AuthProvider(fakeAuthService, navService)),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider.value(value: languageProvider),
        ],
        child: const MyApp(),
      ),
    );

    // Should show splash screen text (fade in)
    await tester.pump(const Duration(milliseconds: 800)); // Halfway through fade
    expect(find.text('تواصل بسهولة في أي وقت'), findsOneWidget);

    // Wait for the splash screen delay to complete
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
