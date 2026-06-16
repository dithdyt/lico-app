import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
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
    final formattedItemPrice = _formatCurrency(itemPrice);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                "BARANG INI AKAN MENGURAS",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  formattedTime.toUpperCase(),
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.black,
                    fontSize: 64,
                    height: 1,
                  ),
                )
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut)
                .shake(delay: 400.ms),
              ),
              const SizedBox(height: 12),
              Text(
                "WAKTU KERJA ANDA.",
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.black,
                ),
              ),
              const SizedBox(height: 36),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName.toUpperCase(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Estimasi Harga: $formattedItemPrice",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              if (isPaylater) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.error.withOpacity(0.3), width: 1),
                  ),
                  child: Text(
                    "PERINGATAN: Anda mengalokasikan $formattedMonthlyTime waktu kerja setiap bulan selama $months bulan ke depan.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().shimmer(duration: 1.seconds),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981), // Emerald Success Green
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () =>
                      _handleDecision(context, ref, DecisionStatus.saved),
                  child: const Text("BATALKAN (SELAMATKAN WAKTU)"),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.error.withOpacity(0.6), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () =>
                      _handleDecision(context, ref, DecisionStatus.burned),
                  child: Text(
                    "LANJUTKAN (BAKAR WAKTU)",
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
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

  Future<void> _handleDecision(
    BuildContext context,
    WidgetRef ref,
    DecisionStatus status,
  ) async {
    await ref
        .read(decisionNotifierProvider.notifier)
        .logDecision(
          itemName: itemName,
          itemPrice: itemPrice,
          timeCostInHours: timeCostInHours,
          isPaylater: isPaylater,
          status: status,
        );

    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      ref.read(calculatorNotifierProvider.notifier).reset();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  String _formatCurrency(double value) {
    if (value.isNaN || value.isInfinite) return "Rp 0";
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }
}
