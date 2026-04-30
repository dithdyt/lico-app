import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/valuation/providers/valuation_provider.dart';
import 'features/valuation/presentation/valuation_screen.dart';
import 'features/ledger/presentation/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: LicoApp(),
    ),
  );
}

class LicoApp extends ConsumerWidget {
  const LicoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valuationState = ref.watch(valuationNotifierProvider);

    return MaterialApp(
      title: 'LICO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: valuationState.when(
        data: (valuation) {
          if (valuation == null) {
            return const ValuationScreen();
          }
          return const DashboardScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFFCCFF00)),
          ),
        ),
        error: (err, stack) => Scaffold(
          body: Center(
            child: Text('Error: $err'),
          ),
        ),
      ),
    );
  }
}
