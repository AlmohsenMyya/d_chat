import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('about') ?? "About"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 120),
              const SizedBox(height: 20),
              Text(
                loc?.translate('app_name') ?? "D-chat",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${loc?.translate('version') ?? "Version"} 1.0.0",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Text(
                loc?.translate('app_description') ?? "Real-time messaging system built with clean architecture and Material 3 design.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(size: 30),
                  const SizedBox(width: 15),
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/3/37/Firebase_Logo.svg',
                    height: 30,
                    errorBuilder: (_, __, ___) => const Icon(Icons.cloud_done, color: Colors.orange),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
