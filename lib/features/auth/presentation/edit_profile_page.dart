import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const _neonGreen = Color(0xFFCCFF00);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSaving = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

    final newPassword = _passwordController.text;
    if (newPassword.isNotEmpty) {
      if (newPassword.length < 6) {
        _showSnackBar('Kata sandi minimal harus 6 karakter.');
        return;
      }
      if (newPassword != _confirmPasswordController.text) {
        _showSnackBar('Konfirmasi kata sandi tidak cocok.');
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      if (newName != user.displayName) {
        await user.updateDisplayName(newName);
      }

      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      await user.reload();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'requires-recent-login') {
        _showSnackBar('Untuk keamanan, silakan logout dan login kembali untuk mengubah kata sandi.');
      } else {
        _showSnackBar(e.message ?? 'Gagal memperbarui profil.');
      }
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('EDIT PROFIL'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Nama Lengkap'),
              const SizedBox(height: 10),
              _buildTextField(controller: _nameController),
              const SizedBox(height: 24),
              _buildLabel('Email'),
              const SizedBox(height: 10),
              _buildTextField(controller: _emailController, readOnly: true),
              const SizedBox(height: 24),
              _buildLabel('Password Baru (Kosongkan jika tidak ingin diubah)'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Konfirmasi Password Baru'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                  },
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _neonGreen,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white24,
                    disabledForegroundColor: Colors.white54,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'SIMPAN PERUBAHAN',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    bool readOnly = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      cursorColor: _neonGreen,
      style: GoogleFonts.inter(
        color: readOnly ? Colors.white70 : Colors.white,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF111111),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _neonGreen, width: 2),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
      ),
    );
  }
}
