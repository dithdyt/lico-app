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

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MASUK\nKE LICO",
                style: GoogleFonts.bebasNeue(
                  color: Colors.white,
                  fontSize: 82,
                  height: 0.9,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 44),
              _buildLabel("EMAIL"),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _emailController,
                hint: "nama@email.com",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              _buildLabel("PASSWORD"),
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
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(
                label: "MASUK",
                isLoading: isLoading,
                onTap: _handleSignIn,
              ),
              const SizedBox(height: 18),
              _buildSecondaryButton(
                label: "MASUK SEBAGAI TAMU",
                isLoading: isLoading,
                onTap: _handleGuestMode,
              ),
              const SizedBox(height: 28),
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
                    style: GoogleFonts.bebasNeue(
                      color: const Color(0xFFCCFF00),
                      fontSize: 20,
                      letterSpacing: 1.1,
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
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal masuk sebagai tamu. Silakan coba lagi."),
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
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            "AKSES DITOLAK",
            style: GoogleFonts.bebasNeue(
              color: Colors.redAccent,
              fontSize: 32,
              letterSpacing: 1.2,
            ),
          ),
          content: Text(
            "Email atau kata sandi yang Anda masukkan salah. Silakan coba lagi.",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "COBA LAGI",
                style: GoogleFonts.bebasNeue(
                  color: const Color(0xFFCCFF00),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.bebasNeue(
        color: const Color(0xFFCCFF00),
        fontSize: 20,
        letterSpacing: 1.4,
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        cursorColor: const Color(0xFFCCFF00),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.white38),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required String label,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFFCCFF00),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.white, offset: Offset(5, 5)),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.bebasNeue(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.bebasNeue(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
