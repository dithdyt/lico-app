import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lico/core/database/database_provider.dart';
import '../domain/user_valuation.dart';

part 'valuation_provider.g.dart';

@riverpod
class ValuationNotifier extends _$ValuationNotifier {
  @override
  Future<UserValuation?> build() async {
    final isar = await ref.watch(isarDatabaseProvider.future);
    return isar.userValuations.where().findFirst();
  }

  Future<void> saveValuation({
    required double monthlyIncome,
    required double weeklyWorkHours,
  }) async {
    if (weeklyWorkHours <= 0) {
      throw Exception("Jam kerja mingguan harus lebih besar dari 0.");
    }
    if (monthlyIncome < 0) {
      throw Exception("Pendapatan bulanan tidak boleh negatif.");
    }

    final isar = await ref.read(isarDatabaseProvider.future);
    
    final valuation = UserValuation()
      ..monthlyIncome = monthlyIncome
      ..weeklyWorkHours = weeklyWorkHours;

    await isar.writeTxn(() async {
      await isar.userValuations.clear();
      await isar.userValuations.put(valuation);
    });

    ref.invalidateSelf();
  }
}
