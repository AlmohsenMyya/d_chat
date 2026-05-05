import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/auth/data/auth_service.dart';
import 'features/chat/data/chat_service.dart';
import 'features/home/provider/home_provider.dart';
import 'core/services/presence_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/connectivity_service.dart';
import 'shared/services/media_service.dart';
import 'features/user/data/user_service.dart';
import 'features/user/provider/user_provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_themes.dart';
import 'core/localization/language_provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/navigation_service.dart';
import 'shared/widgets/connectivity_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
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
        Provider<ConnectivityService>(create: (_) => ConnectivityService()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UserService>(create: (_) => UserService()),
        Provider<NotificationService>(create: (_) => NotificationService()),
        Provider<MediaService>(create: (_) => MediaService()),
        ProxyProvider2<UserService, NotificationService, ChatService>(
          update: (_, userService, notificationService, __) =>
              ChatService(userService, notificationService),
        ),
        Provider<PresenceService>(create: (_) => PresenceService()),
        ChangeNotifierProxyProvider5<AuthService, NavigationService, MediaService, PresenceService, NotificationService, AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthService>(),
            context.read<NavigationService>(),
            context.read<MediaService>(),
            context.read<PresenceService>(),
            context.read<NotificationService>(),
          ),
          update: (context, authService, navService, mediaService, presenceService, notificationService, authProvider) =>
              authProvider ?? AuthProvider(authService, navService, mediaService, presenceService, notificationService),
        ),
        ChangeNotifierProxyProvider3<UserService, NavigationService, AuthProvider, UserProvider?>(
          create: (context) => null,
          update: (context, userService, navService, authProvider, previous) {
            if (authProvider.user == null) return null;
            return previous ?? UserProvider(userService, navService, authProvider.user!.uid);
          },
        ),
        ChangeNotifierProxyProvider2<ChatService, AuthProvider, HomeProvider?>(
          create: (context) => null,
          update: (context, chatService, authProvider, previous) {
            if (authProvider.user == null) return null;
            return previous ?? HomeProvider(
              chatService,
              context.read<NavigationService>(),
              authProvider.user!.uid,
            );
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
      builder: (context, child) {
        return ConnectivityWrapper(child: child!);
      },
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
