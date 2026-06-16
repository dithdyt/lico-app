import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final newName = _nameController.text.trim();

    if (user == null) {
      _showSnackBar('Sesi pengguna tidak ditemukan.');
      return;
    }

    if (newName.isEmpty) {
      _showSnackBar('Nama lengkap tidak boleh kosong.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await user.updateDisplayName(newName);
      await user.reload();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      _showSnackBar('Gagal memperbarui profil. Silakan coba lagi.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PROFIL'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('NAMA LENGKAP'),
              const SizedBox(height: 10),
              _buildTextField(controller: _nameController),
              const SizedBox(height: 24),
              _buildLabel('EMAIL'),
              const SizedBox(height: 10),
              _buildTextField(controller: _emailController, readOnly: true),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('SIMPAN PERUBAHAN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.primary.withOpacity(0.8),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: readOnly ? theme.colorScheme.onSurface.withOpacity(0.5) : theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly ? theme.colorScheme.surface.withOpacity(0.5) : theme.colorScheme.surface,
      ),
    );
  }
}
