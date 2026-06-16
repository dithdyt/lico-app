import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lico/core/database/database_provider.dart';
import 'package:lico/features/auth/providers/auth_provider.dart';
import 'package:lico/features/ledger/providers/ledger_provider.dart';
import '../domain/decision_log.dart';

part 'decision_provider.g.dart';

@riverpod
class DecisionNotifier extends _$DecisionNotifier {
  @override
  void build() {}

  Future<void> logDecision({
    required String itemName,
    required double itemPrice,
    required double timeCostInHours,
    required bool isPaylater,
    required DecisionStatus status,
  }) async {
    final userId = ref.read(authControllerProvider).valueOrNull?.userId;
    if (userId == null) {
      throw Exception("Sesi pengguna tidak valid.");
    }

    final isar = await ref.read(isarDatabaseProvider.future);

    final log = DecisionLog()
      ..userId = userId
      ..itemName = itemName
      ..itemPrice = itemPrice
      ..timeCostInHours = timeCostInHours
      ..isPaylater = isPaylater
      ..status = status
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.decisionLogs.put(log);
    });

    ref.invalidate(ledgerNotifierProvider);
  }

  Future<void> deleteDecision(int id) async {
    final userId = ref.read(authControllerProvider).valueOrNull?.userId;
    if (userId == null) return;

    final isar = await ref.read(isarDatabaseProvider.future);
    final log = await isar.decisionLogs.get(id);
    if (log?.userId != userId) return;

    await isar.writeTxn(() async {
      await isar.decisionLogs.delete(id);
    });

    ref.invalidate(ledgerNotifierProvider);
  }
}
