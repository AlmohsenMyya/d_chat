import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/localization/app_localizations.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('developer') ?? "Developer"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              "Almohsen Myya",
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              loc?.translate('dev_title') ?? "Software Engineer — Mobile Systems",
              style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  loc?.translate('dev_desc') ?? "Focused on building scalable, maintainable systems using clean architecture principles.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                loc?.translate('social_links') ?? "Social Links",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            _buildSocialTile(
              context,
              icon: Icons.code,
              label: loc?.translate('github') ?? "GitHub",
              url: "https://github.com/AlmohsenMyya",
            ),
            _buildSocialTile(
              context,
              icon: Icons.link,
              label: loc?.translate('linkedin') ?? "LinkedIn",
              url: "https://www.linkedin.com/in/almohsen-myya-79230022b?utm_source=share_via&utm_content=profile&utm_medium=member_android",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialTile(BuildContext context, {required IconData icon, required String label, required String url}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => _launchUrl(url),
      ),
    );
  }
}
