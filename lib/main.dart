import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/auth/data/auth_service.dart';
import 'features/chat/data/chat_service.dart';
import 'features/chat/provider/chat_provider.dart';
import 'features/user/data/user_service.dart';
import 'features/user/provider/user_provider.dart';
import 'features/user/data/user_model.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_themes.dart';
import 'core/localization/language_provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/navigation_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  final navigationService = NavigationService();

  runApp(
    MultiProvider(
      providers: [
        Provider<NavigationService>.value(value: navigationService),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UserService>(create: (_) => UserService()),
        Provider<ChatService>(create: (_) => ChatService()),
        ChangeNotifierProxyProvider2<AuthService, NavigationService, AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthService>(),
            context.read<NavigationService>(),
          ),
          update: (context, authService, navService, authProvider) =>
              authProvider ?? AuthProvider(authService, navService),
        ),
        ChangeNotifierProxyProvider3<UserService, NavigationService, AuthProvider, UserProvider?>(
          create: (context) => null,
          update: (context, userService, navService, authProvider, previous) {
            if (authProvider.user == null) return null;
            return previous ?? UserProvider(userService, navService, authProvider.user!.uid);
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();
    final navService = context.read<NavigationService>();

    return MaterialApp(
      title: 'D-chat',
      navigatorKey: navService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: languageProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
