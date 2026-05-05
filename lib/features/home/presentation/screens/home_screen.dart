import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/navigation_service.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../provider/home_provider.dart';
import '../widgets/chat_tile.dart';
import '../../../../shared/widgets/shimmer_skeletons.dart';

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
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 20, left: 16, right: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 33,
                      backgroundImage: authProvider.user?.photoURL != null
                          ? NetworkImage(authProvider.user!.photoURL!)
                          : null,
                      child: authProvider.user?.photoURL == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    authProvider.user?.displayName ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    authProvider.user?.email ?? "",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildDrawerItem(
              context: context,
              icon: Icons.person_outline,
              label: loc?.translate('profile') ?? "Profile",
              onTap: () {
                Navigator.pop(context);
                navService.navigateTo(AppRoutes.profile);
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.settings_outlined,
              label: loc?.translate('settings') ?? "Settings",
              onTap: () {
                Navigator.pop(context);
                navService.navigateTo(AppRoutes.settings);
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.logout,
              label: loc?.translate('logout') ?? "Logout",
              color: Colors.redAccent,
              onTap: () => authProvider.signOut(),
            ),
            const Divider(indent: 20, endIndent: 20),

            Image.asset('assets/logo.png', height: 200),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${loc?.translate('version') ?? "Version"} 1.0.0",
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: _buildChatList(loc, homeProvider, authProvider.user?.uid),

      // IndexedStack(
      //   index: _currentIndex,
      //   children: [
      //     _buildChatList(loc, homeProvider, authProvider.user?.uid),
      //     const SettingsScreen(),
      //   ],
      // ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => navService.navigateTo(AppRoutes.users),
              child: const Icon(Icons.message),
            )
          : null,

    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildChatList(AppLocalizations? loc, HomeProvider? provider, String? currentUserId) {
    if (provider == null || provider.isLoading) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => const ShimmerChatTile(),
      );
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
