import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('help_support') ?? "Help & Support"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            loc?.translate('faq') ?? "Frequently Asked Questions",
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFAQTile(
            context,
            loc?.translate('faq_chat_title') ?? "How to start a chat?",
            loc?.translate('faq_chat_desc') ?? "Go to the Users tab, search for a friend, and tap on their name to start messaging.",
          ),
          _buildFAQTile(
            context,
            loc?.translate('faq_profile_title') ?? "How to update profile?",
            loc?.translate('faq_profile_desc') ?? "Open the drawer, go to Profile, change your name or photo, and tap Save.",
          ),
          _buildFAQTile(
            context,
            loc?.translate('faq_notif_title') ?? "How notifications work?",
            loc?.translate('faq_notif_desc') ?? "You will receive instant push notifications when someone sends you a message, even in the background.",
          ),
          const SizedBox(height: 30),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(Icons.support_agent, size: 50, color: Colors.blueAccent),
                  const SizedBox(height: 10),
                  const Text("almohsenmyya1999@gmail.com", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Support team will be with you shortly")),
                      );
                    },
                    child: Text(loc?.translate('contact_support') ?? "Contact Support"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTile(BuildContext context, String title, String description) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(description, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
