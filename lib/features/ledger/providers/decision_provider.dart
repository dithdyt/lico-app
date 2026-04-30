import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lico/core/database/database_provider.dart';
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
    final isar = await ref.read(isarDatabaseProvider.future);
    
    final log = DecisionLog()
      ..itemName = itemName
      ..itemPrice = itemPrice
      ..timeCostInHours = timeCostInHours
      ..isPaylater = isPaylater
      ..status = status
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.decisionLogs.put(log);
    });
  }
}
