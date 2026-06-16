import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lico/features/auth/presentation/sign_up_screen.dart';
import 'package:lico/features/auth/providers/auth_provider.dart';
import 'package:lico/features/ledger/presentation/dashboard_screen.dart';
import 'package:lico/features/valuation/presentation/valuation_screen.dart';
import 'package:lico/features/valuation/providers/valuation_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MASUK",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.extrabold,
                  height: 0.9,
                ),
              ),
              Text(
                "KE LICO",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.extrabold,
                  color: theme.colorScheme.primary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Hitung nilai waktu dan kelola keuangan Anda dengan cara yang lebih cerdas.",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 48),
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
                hint: "••••••••",
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
                label: "MASUK",
                isLoading: isLoading,
                onTap: _handleSignIn,
              ),
              const SizedBox(height: 16),
              _buildSecondaryButton(
                context: context,
                label: "MASUK SEBAGAI TAMU",
                isLoading: isLoading,
                onTap: _handleGuestMode,
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                  child: Text(
                    "BELUM PUNYA AKUN? DAFTAR",
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

  Future<void> _handleSignIn() async {
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(_emailController.text, _passwordController.text);
      await _openAppEntry();
    } on FirebaseAuthException {
      if (!mounted) return;
      await _showSignInErrorDialog();
    } catch (_) {
      if (!mounted) return;
      await _showSignInErrorDialog();
    }
  }

  Future<void> _handleGuestMode() async {
    try {
      await ref.read(authControllerProvider.notifier).enterGuestMode();
      await _openAppEntry();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "Gagal masuk sebagai tamu. Silakan coba lagi.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Future<void> _openAppEntry() async {
    ref.invalidate(valuationNotifierProvider);
    final valuation = await ref.read(valuationNotifierProvider.future);

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => valuation == null
            ? const ValuationScreen()
            : const DashboardScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _showSignInErrorDialog() {
    final theme = Theme.of(context);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "AKSES DITOLAK",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Email atau kata sandi yang Anda masukkan salah. Silakan coba lagi.",
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "COBA LAGI",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
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

  Widget _buildSecondaryButton({
    required BuildContext context,
    required String label,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.4), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
