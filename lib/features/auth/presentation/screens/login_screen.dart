import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc?.translate('login') ?? 'Login')),
      body: const Center(child: Text('Login Screen Implementation Coming Soon')),
    );
  }
}
