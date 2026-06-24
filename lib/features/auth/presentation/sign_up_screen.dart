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

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(error.toString()),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DAFTAR\nAKUN",
                style: GoogleFonts.bebasNeue(
                  color: Colors.white,
                  fontSize: 82,
                  height: 0.9,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 44),
              _buildLabel("NAMA LENGKAP"),
              const SizedBox(height: 10),
              _buildTextField(controller: _nameController, hint: "Nama Anda"),
              const SizedBox(height: 24),
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
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(
                label: "DAFTAR",
                isLoading: isLoading,
                onTap: _handleSignUp,
              ),
              const SizedBox(height: 28),
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
      Navigator.of(context).popUntil((route) => route.isFirst);
      messenger.showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFCCFF00),
          content: Text(
            'Pendaftaran berhasil! Silakan masuk menggunakan akun baru Anda.',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (_) {
      // Error feedback is handled by the auth provider listener above.
    }
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
        enableSuggestions: false,
        autocorrect: false,
        autofillHints: const [],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        cursorColor: const Color(0xFFCCFF00),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
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
}
