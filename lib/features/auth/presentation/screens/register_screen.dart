import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc?.translate('register') ?? 'Register')),
      body: const Center(child: Text('Register Screen Implementation Coming Soon')),
    );
  }
}
