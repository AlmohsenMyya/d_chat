import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('settings') ?? "Settings"),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(loc?.translate('appearance') ?? "Appearance"),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(loc?.translate('dark_mode') ?? "Dark Mode"),
            trailing:Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),
          const Divider(),
          _buildSectionHeader(loc?.translate('language') ?? "Language"),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(loc?.translate('app_language') ?? "App Language"),
            subtitle: Text(languageProvider.locale.languageCode == 'ar' ? "العربية" : "English"),
            trailing: DropdownButton<String>(
              value: languageProvider.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text("English")),
                DropdownMenuItem(value: 'ar', child: Text("العربية")),
              ],
              onChanged: (value) {
                if (value != null) {
                  languageProvider.setLocale(Locale(value));
                }
              },
            ),
          ),
          const Divider(),
          _buildSectionHeader(loc?.translate('about') ?? "About"),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(loc?.translate('version') ?? "Version"),
            trailing: const Text("1.0.0"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
