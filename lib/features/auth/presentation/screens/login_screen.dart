import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                return auth.isLoading
                    ? LinearProgressIndicator(color: Theme.of(context).primaryColor)
                    : const SizedBox(height: 4);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png', height: 100),
                      const SizedBox(height: 20),
                      Text(
                        loc?.translate('app_name') ?? "D-chat",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        controller: _emailController,
                        hintText: loc?.translate('email') ?? "Email",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc?.translate('field_required');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: loc?.translate('password') ?? "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscureText,
                        onToggleVisibility: () => setState(() => _obscureText = !_obscureText),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc?.translate('field_required');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          if (auth.errorMessage != null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc?.translate(auth.errorMessage!) ?? auth.errorMessage!)),
                              );
                              auth.clearError();
                            });
                          }
                          return ElevatedButton(
                            onPressed: auth.isLoading ? null : () {
                              if (_formKey.currentState!.validate()) {
                                auth.signIn(_emailController.text.trim(), _passwordController.text.trim());
                              }
                            },
                            child: auth.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(loc?.translate('login') ?? "Login"),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(loc?.translate('no_account') ?? "Don't have an account?"),
                          TextButton(
                            onPressed: () => authProvider.signOut(), // Use signOut to clear and go to login/onboarding if needed
                            child: Text(loc?.translate('create_account') ?? "Create Account"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
