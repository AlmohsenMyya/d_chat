import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/navigation_service.dart';
import '../../../auth/provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = context.read<AuthProvider>();
    final navService = context.read<NavigationService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('app_name') ?? "D-chat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.signOut(),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Center(child: Text(loc?.translate('no_chats_yet') ?? "No conversations yet")),
          const Center(child: Text("Settings (Sprint 6)")),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => navService.navigateTo(AppRoutes.users),
              child: const Icon(Icons.message),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            activeIcon: const Icon(Icons.chat_bubble),
            label: loc?.translate('chats') ?? "Chats",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: loc?.translate('settings') ?? "Settings",
          ),
        ],
      ),
    );
  }
}
