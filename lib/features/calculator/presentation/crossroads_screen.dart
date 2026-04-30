import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lico/core/utils/time_formatter.dart';
import 'package:lico/features/ledger/domain/decision_log.dart';
import 'package:lico/features/ledger/providers/decision_provider.dart';
import '../providers/calculator_provider.dart';

class CrossroadsScreen extends ConsumerWidget {
  final String itemName;
  final double itemPrice;
  final double timeCostInHours;
  final bool isPaylater;
  final int months;

  const CrossroadsScreen({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.timeCostInHours,
    required this.isPaylater,
    required this.months,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formattedTime = TimeFormatter.formatHours(timeCostInHours);
    final monthlyTimeCost = timeCostInHours / months;
    final formattedMonthlyTime = TimeFormatter.formatHours(monthlyTimeCost);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ANDA MENUKAR",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  formattedTime.toUpperCase(),
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: const Color(0xFFCCFF00),
                    fontSize: 84,
                    height: 1,
                  ),
                ).animate().scale(duration: 400.ms, curve: Curves.elasticOut).shake(delay: 400.ms),
              ),
              const SizedBox(height: 8),
              Text(
                "HIDUP ANDA.",
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 48),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName.toUpperCase(),
                      style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ESTIMASI HARGA: Rp ${itemPrice.toStringAsFixed(0)}",
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              
              if (isPaylater) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: Text(
                    "PERINGATAN: ANDA MENGGADAIKAN $formattedMonthlyTime HIDUP ANDA SETIAP BULAN SELAMA $months BULAN KE DEPAN.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ).animate().shimmer(duration: 1.seconds),
              ],
              
              const Spacer(),
              
              _buildBrutalButton(
                context: context,
                label: "BATALKAN (SELAMATKAN WAKTU)",
                color: const Color(0xFFCCFF00),
                onPressed: () => _handleDecision(context, ref, DecisionStatus.saved),
              ),
              
              const SizedBox(height: 20),
              
              _buildBrutalButton(
                context: context,
                label: "LANJUTKAN (BAKAR WAKTU)",
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () => _handleDecision(context, ref, DecisionStatus.burned),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleDecision(BuildContext context, WidgetRef ref, DecisionStatus status) async {
    // Show a quick loading state if possible, or just the delay
    await ref.read(decisionNotifierProvider.notifier).logDecision(
      itemName: itemName,
      itemPrice: itemPrice,
      timeCostInHours: timeCostInHours,
      isPaylater: isPaylater,
      status: status,
    );

    // FSD 4: Action Feedback (1s delay)
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      // Reset calculator state
      ref.read(calculatorNotifierProvider.notifier).reset();
      
      // Return to Dashboard (the first screen in the stack)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Widget _buildBrutalButton({
    required BuildContext context,
    required String label,
    required Color color,
    Color textColor = Colors.black,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Stack(
          children: [
            Positioned(
              top: 4,
              left: 4,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
            Positioned.fill(
              right: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: textColor,
                    ),
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
