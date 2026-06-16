import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/valuation/domain/user_valuation.dart';
import '../../features/ledger/domain/decision_log.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
class IsarDatabase extends _$IsarDatabase {
  @override
  Future<Isar> build() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([
      UserValuationSchema,
      DecisionLogSchema,
    ], directory: dir.path);
  }

  Future<void> resetLocalData() async {
    final isar = await future;
    await isar.writeTxn(() async {
      await isar.userValuations.clear();
      await isar.decisionLogs.clear();
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    await isar.close();
    ref.invalidateSelf();
  }

  Future<void> clearUserData(String userId) async {
    final isar = await future;
    await isar.writeTxn(() async {
      await isar.userValuations.filter().userIdEqualTo(userId).deleteAll();
      await isar.decisionLogs.filter().userIdEqualTo(userId).deleteAll();
    });
  }
}
