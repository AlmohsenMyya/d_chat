import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/shimmer_skeletons.dart';
import '../../provider/user_provider.dart';
import '../../data/user_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final userProvider = context.watch<UserProvider?>();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('users') ?? "Users"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              hintText: loc?.translate('search_users') ?? "Search users...",
              icon: Icons.search,
              onChanged: (value) => userProvider?.setSearchQuery(value),
            ),
          ),
          Expanded(
            child: userProvider == null || userProvider.isLoading
                ? ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) => const ShimmerUserTile(),
                  )
                : userProvider.users.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.person_search_outlined,
                        message: loc?.translate('no_users_found') ?? "No users found",
                      )
                    : ListView.builder(
                        itemCount: userProvider.users.length,
                        itemBuilder: (context, index) {
                          final user = userProvider.users[index];
                          return _UserTile(user: user, onTap: () => userProvider.selectUser(user));
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const _UserTile({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          Hero(
            tag: 'avatar_${user.uid}',
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: user.isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(user.isOnline ? (loc?.translate('online') ?? "Online") : (loc?.translate('offline') ?? "Offline")),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
