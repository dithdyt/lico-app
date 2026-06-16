import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lico/features/auth/presentation/sign_in_screen.dart';
import 'package:lico/features/auth/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: theme.colorScheme.error,
              content: Text(
                error.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DAFTAR",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.extrabold,
                  height: 0.9,
                ),
              ),
              Text(
                "AKUN BARU",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.extrabold,
                  color: theme.colorScheme.primary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Mulai langkah awal mengelola anggaran waktu dan keuangan Anda.",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 44),
              _buildLabel(context, "NAMA LENGKAP"),
              const SizedBox(height: 10),
              _buildTextField(controller: _nameController, hint: "Nama Anda"),
              const SizedBox(height: 24),
              _buildLabel(context, "EMAIL"),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _emailController,
                hint: "nama@email.com",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              _buildLabel(context, "PASSWORD"),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _passwordController,
                hint: "Minimal 6 karakter",
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(
                context: context,
                label: "DAFTAR",
                isLoading: isLoading,
                onTap: _handleSignUp,
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                            (route) => false,
                          );
                        },
                  child: Text(
                    "SUDAH PUNYA AKUN? MASUK",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      letterSpacing: 0.5,
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

  Future<void> _handleSignUp() async {
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signUp(
            _emailController.text,
            _passwordController.text,
            _nameController.text,
          );

      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      final theme = Theme.of(context);
      Navigator.of(context).popUntil((route) => route.isFirst);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: theme.colorScheme.primary,
          content: Text(
            'Pendaftaran berhasil! Silakan masuk menggunakan akun baru Anda.',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } catch (_) {
      // Error feedback is handled by the auth provider listener above.
    }
  }

  Widget _buildLabel(BuildContext context, String label) {
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
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildSubmitButton({
    required BuildContext context,
    required String label,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(label),
      ),
    );
  }
}
