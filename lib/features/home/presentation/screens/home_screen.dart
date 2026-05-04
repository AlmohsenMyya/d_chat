import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/navigation_service.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../provider/home_provider.dart';
import '../widgets/chat_tile.dart';

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
    final homeProvider = context.watch<HomeProvider?>();

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
          _buildChatList(loc, homeProvider, authProvider.user?.uid),
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

  Widget _buildChatList(AppLocalizations? loc, HomeProvider? provider, String? currentUserId) {
    if (provider == null || provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.chats.isEmpty) {
      return Center(child: Text(loc?.translate('no_chats_yet') ?? "No conversations yet"));
    }

    return ListView.builder(
      itemCount: provider.chats.length,
      itemBuilder: (context, index) {
        final chatData = provider.chats[index];
        return ChatTile(
          chatData: chatData,
          currentUserId: currentUserId ?? "",
          onTap: (user) => provider.openChat(user),
        );
      },
    );
  }
}
