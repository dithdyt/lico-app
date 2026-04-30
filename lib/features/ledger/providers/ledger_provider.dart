import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lico/core/database/database_provider.dart';
import '../domain/decision_log.dart';

part 'ledger_provider.g.dart';

class LedgerData {
  final List<DecisionLog> allLogs;
  final double totalBurnedHours;
  final double totalSavedHours;

  LedgerData({
    required this.allLogs,
    required this.totalBurnedHours,
    required this.totalSavedHours,
  });

  List<DecisionLog> get burnedLogs => 
      allLogs.where((log) => log.status == DecisionStatus.burned).toList();
      
  List<DecisionLog> get savedLogs => 
      allLogs.where((log) => log.status == DecisionStatus.saved).toList();
}

@riverpod
class LedgerNotifier extends _$LedgerNotifier {
  @override
  Future<LedgerData> build() async {
    final isar = await ref.watch(isarDatabaseProvider.future);
    
    // Watch for changes in the collection to trigger re-builds
    final stream = isar.decisionLogs.watchLazy();
    final subscription = stream.listen((_) {
      ref.invalidateSelf();
    });
    ref.onDispose(subscription.cancel);
    
    // Get current month boundaries
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final logs = await isar.decisionLogs
        .filter()
        .createdAtBetween(firstDayOfMonth, lastDayOfMonth)
        .sortByCreatedAtDesc()
        .findAll();

    double totalBurned = 0;
    double totalSaved = 0;

    for (final log in logs) {
      if (log.status == DecisionStatus.burned) {
        totalBurned += log.timeCostInHours;
      } else {
        totalSaved += log.timeCostInHours;
      }
    }

    return LedgerData(
      allLogs: logs,
      totalBurnedHours: totalBurned,
      totalSavedHours: totalSaved,
    );
  }
}
