import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lico/core/database/database_provider.dart';
import 'package:lico/features/auth/providers/auth_provider.dart';
import 'package:lico/features/valuation/domain/user_valuation.dart';
import 'package:lico/features/valuation/providers/valuation_provider.dart';
import '../domain/decision_log.dart';

part 'ledger_provider.g.dart';

const double _workDaysPerMonth = 22;
const double _incomeBudgetUnit = 1000000;

class LedgerData {
  final List<DecisionLog> allLogs;
  final double totalBurnedHours;
  final double totalSavedHours;
  final double timeBudget;
  final double todayBurnedHours;
  final double hourlyRate;

  LedgerData({
    required this.allLogs,
    required this.totalBurnedHours,
    required this.totalSavedHours,
    required this.timeBudget,
    required this.todayBurnedHours,
    required this.hourlyRate,
  });

  bool get hasValidValuation =>
      timeBudget.isFinite &&
      hourlyRate.isFinite &&
      timeBudget > 0 &&
      hourlyRate > 0;

  double get remainingTime {
    if (!hasValidValuation) return 0;

    final remaining = timeBudget - totalBurnedHours;
    if (remaining.isNaN || remaining.isInfinite) return 0;
    return remaining;
  }

  double get progress {
    if (!hasValidValuation) return 0;

    final value = remainingTime / timeBudget;
    if (value.isNaN || value.isInfinite) return 0;
    return value.clamp(0, 1).toDouble();
  }

  List<DecisionLog> get burnedLogs =>
      allLogs.where((log) => log.status == DecisionStatus.burned).toList();

  List<DecisionLog> get savedLogs =>
      allLogs.where((log) => log.status == DecisionStatus.saved).toList();
}

@riverpod
class LedgerNotifier extends _$LedgerNotifier {
  @override
  Future<LedgerData> build() async {
    final userId = ref.watch(authControllerProvider).valueOrNull?.userId;
    if (userId == null) {
      return LedgerData(
        allLogs: const [],
        totalBurnedHours: 0,
        totalSavedHours: 0,
        timeBudget: 0,
        todayBurnedHours: 0,
        hourlyRate: 0,
      );
    }

    final isar = await ref.watch(isarDatabaseProvider.future);
    final valuation = await ref.watch(valuationNotifierProvider.future);

    // Watch valuation and decision changes so dashboard math stays synchronized.
    final decisionSubscription = isar.decisionLogs.watchLazy().listen((_) {
      ref.invalidateSelf();
    });
    final valuationSubscription = isar.userValuations.watchLazy().listen((_) {
      ref.invalidateSelf();
    });
    ref.onDispose(decisionSubscription.cancel);
    ref.onDispose(valuationSubscription.cancel);

    final dailyWorkHours = valuation?.dailyWorkHours ?? 0;
    final monthlyIncome = valuation?.monthlyIncome ?? 0;
    final baseWorkHours = dailyWorkHours > 0
        ? dailyWorkHours * _workDaysPerMonth
        : 0.0;
    final incomeMultiplier = monthlyIncome > 0
        ? monthlyIncome / _incomeBudgetUnit
        : 0.0;
    final timeBudget = baseWorkHours * incomeMultiplier;
    final hourlyRate = baseWorkHours > 0 && monthlyIncome > 0
        ? monthlyIncome / baseWorkHours
        : 0.0;

    // Get current month boundaries
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    // Today boundaries
    final startOfToday = DateTime(now.year, now.month, now.day);

    final logs = await isar.decisionLogs
        .filter()
        .userIdEqualTo(userId)
        .createdAtBetween(firstDayOfMonth, lastDayOfMonth)
        .sortByCreatedAtDesc()
        .findAll();

    double totalBurned = 0;
    double totalSaved = 0;
    double todayBurned = 0;

    for (final log in logs) {
      final liveTimeCost = hourlyRate > 0 && log.itemPrice > 0
          ? log.itemPrice / hourlyRate
          : log.timeCostInHours;
      final safeTimeCost = liveTimeCost.isFinite ? liveTimeCost : 0.0;
      log.timeCostInHours = safeTimeCost;

      if (log.status == DecisionStatus.burned) {
        totalBurned += safeTimeCost;
        // Check if today
        if (log.createdAt.isAfter(startOfToday)) {
          todayBurned += safeTimeCost;
        }
      } else {
        totalSaved += safeTimeCost;
      }
    }

    return LedgerData(
      allLogs: logs,
      totalBurnedHours: totalBurned,
      totalSavedHours: totalSaved,
      timeBudget: timeBudget,
      todayBurnedHours: todayBurned,
      hourlyRate: hourlyRate,
    );
  }
}
