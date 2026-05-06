import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/user/presentation/screens/users_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/user/data/user_model.dart';
import '../../features/chat/provider/chat_provider.dart';
import '../../features/chat/data/chat_service.dart';
import '../../shared/services/media_service.dart';
import '../../features/auth/provider/auth_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/provider/profile_provider.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/privacy_security_screen.dart';
import '../../features/settings/presentation/screens/help_support_screen.dart';
import '../../features/settings/presentation/screens/about_screen.dart';
import '../../features/settings/presentation/screens/developer_screen.dart';
import '../../features/settings/provider/privacy_provider.dart';
import '../../features/user/data/user_service.dart';
import '../../features/auth/data/auth_service.dart';
import 'navigation_service.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String users = '/users';
  static const String chat = '/chat';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String privacy = '/privacy';
  static const String help = '/help';
  static const String about = '/about';
  static const String developer = '/developer';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case users:
        return MaterialPageRoute(builder: (_) => const UsersScreen());
      case profile:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ProfileProvider(
              context.read<UserService>(),
              context.read<MediaService>(),
              context.read<AuthService>(),
            ),
            child: const ProfileScreen(),
          ),
        );
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case privacy:
        return MaterialPageRoute(
          builder: (context) => Consumer<PrivacyProvider>(
            builder: (_, provider, __) => const PrivacySecurityScreen(),
          ),
        );
      case help:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case developer:
        return MaterialPageRoute(builder: (_) => const DeveloperScreen());
      case chat:
        final targetUser = routeSettings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) {
            final authProvider = context.read<AuthProvider>();
            return ChangeNotifierProvider(
              create: (context) => ChatProvider(
                context.read<ChatService>(),
                context.read<NavigationService>(),
                context.read<MediaService>(),
                authProvider.user!.uid,
                targetUser.uid,
              ),
              child: ChatScreen(user: targetUser),
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${routeSettings.name}')),
          ),
        );
    }
  }
}
