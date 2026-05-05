import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../provider/profile_provider.dart';
import '../../../auth/provider/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _nameController = TextEditingController(text: authProvider.user?.displayName ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final user = authProvider.user;

    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('profile') ?? "Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profileProvider.pickedImage != null
                        ? FileImage(profileProvider.pickedImage!)
                        : (user.photoURL != null
                            ? NetworkImage(user.photoURL!) as ImageProvider
                            : null),
                    child: (profileProvider.pickedImage == null && user.photoURL == null)
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: () => profileProvider.pickImage(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: loc?.translate('name') ?? "Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc?.translate('field_required');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: user.email,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: loc?.translate('email') ?? "Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  // filled: true,
                  // fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: profileProvider.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await profileProvider.updateProfile(
                              user.uid,
                              _nameController.text.trim(),
                            );
                            if (success && mounted) {
                              await authProvider.refreshUser(); // 👈 تحديث الحالة العالمية فوراً
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc?.translate('profile_updated') ?? "Profile updated")),
                              );
                            }
                          }
                        },
                  child: profileProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(loc?.translate('save') ?? "Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
