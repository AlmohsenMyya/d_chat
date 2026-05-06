import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../provider/privacy_provider.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final privacyProvider = context.watch<PrivacyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('privacy_security') ?? "Privacy & Security"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                loc?.translate('privacy_desc') ?? "Control who can see your activity and messages. We value your privacy.",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: Text(loc?.translate('show_last_seen') ?? "Show Last Seen"),
            value: privacyProvider.showLastSeen,
            onChanged: (value) => privacyProvider.toggleLastSeen(value),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SwitchListTile(
            title: Text(loc?.translate('allow_read_receipts') ?? "Allow Read Receipts"),
            value: privacyProvider.allowReadReceipts,
            onChanged: (value) => privacyProvider.toggleReadReceipts(value),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          const Divider(height: 40),
          ListTile(
            leading: const Icon(Icons.block, color: Colors.redAccent),
            title: Text(loc?.translate('blocked_users') ?? "Blocked Users"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Mock UI only as per requirements
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Blocked users list coming soon")),
              );
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
    );
  }
}
