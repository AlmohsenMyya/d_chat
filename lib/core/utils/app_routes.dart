import 'package:flutter/material.dart';
import '../../shared/widgets/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/user/presentation/screens/users_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/user/data/user_model.dart';

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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
      case chat:
        final targetUser = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) {
            final authProvider = context.read<AuthProvider>();
            return ChangeNotifierProvider(
              create: (context) => ChatProvider(
                context.read<ChatService>(),
                context.read<NavigationService>(),
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
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
