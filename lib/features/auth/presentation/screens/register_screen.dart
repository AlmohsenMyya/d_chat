import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('create_account') ?? "Create Account"),
      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          return GestureDetector(
                            onTap: () => auth.pickProfileImage(),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: auth.pickedImage != null ? FileImage(auth.pickedImage!) : null,
                                  child: auth.pickedImage == null
                                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: _nameController,
                        hintText: loc?.translate('full_name') ?? "Full Name",
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc?.translate('field_required');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: loc?.translate('confirm_password') ?? "Confirm Password",
                        icon: Icons.lock_reset,
                        isPassword: true,
                        obscureText: _obscureText,
                        onToggleVisibility: () => setState(() => _obscureText = !_obscureText),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return loc?.translate('passwords_dont_match');
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
                                auth.signUp(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _nameController.text.trim(),
                                );
                              }
                            },
                            child: auth.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(loc?.translate('register') ?? "Register"),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(loc?.translate('have_account') ?? "Already have an account?"),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(loc?.translate('login') ?? "Login"),
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
