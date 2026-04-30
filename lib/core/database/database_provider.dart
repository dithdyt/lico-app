import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/valuation/domain/user_valuation.dart';
import '../../features/ledger/domain/decision_log.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
class IsarDatabase extends _$IsarDatabase {
  @override
  Future<Isar> build() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [UserValuationSchema, DecisionLogSchema],
      directory: dir.path,
    );
  }
}
