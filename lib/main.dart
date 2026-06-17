import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/sign_in_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/valuation/providers/valuation_provider.dart';
import 'features/valuation/presentation/valuation_screen.dart';
import 'features/ledger/presentation/dashboard_screen.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: LicoApp()));
}

class LicoApp extends ConsumerWidget {
  const LicoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'LICO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      data: (session) {
        if (!session.canEnterApp) {
          return const SignInScreen();
        }

        return const _ValuationGate();
      },
      loading: () => const _LicoLoadingScreen(),
      error: (err, stack) => const SignInScreen(),
    );
  }
}

class _ValuationGate extends ConsumerWidget {
  const _ValuationGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valuationState = ref.watch(valuationNotifierProvider);

    return valuationState.when(
      data: (valuation) {
        if (valuation == null) {
          return const ValuationScreen();
        }
        return const DashboardScreen();
      },
      loading: () => const _LicoLoadingScreen(),
      error: (err, stack) => _LicoErrorScreen(message: err.toString()),
    );
  }
}

class _LicoLoadingScreen extends StatelessWidget {
  const _LicoLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xFFCCFF00))),
    );
  }
}

class _LicoErrorScreen extends StatelessWidget {
  final String message;

  const _LicoErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Error: $message')));
  }
}
