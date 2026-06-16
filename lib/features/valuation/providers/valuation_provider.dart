import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lico/core/database/database_provider.dart';
import 'package:lico/features/auth/providers/auth_provider.dart';
import '../domain/user_valuation.dart';

part 'valuation_provider.g.dart';

@riverpod
class ValuationNotifier extends _$ValuationNotifier {
  @override
  Future<UserValuation?> build() async {
    final userId = ref.watch(authControllerProvider).valueOrNull?.userId;
    if (userId == null) return null;

    final isar = await ref.watch(isarDatabaseProvider.future);
    final valuations = await isar.userValuations
        .filter()
        .userIdEqualTo(userId)
        .findAll();
    final valuation = _latestValuation(valuations);
    if (valuation == null || valuation.dailyWorkHours <= 0) return null;
    return valuation;
  }

  Future<void> saveValuation({
    required double monthlyIncome,
    required double dailyWorkHours,
  }) async {
    if (!dailyWorkHours.isFinite || dailyWorkHours <= 0) {
      throw Exception("Jam kerja per hari harus lebih besar dari 0.");
    }
    if (!monthlyIncome.isFinite || monthlyIncome < 0) {
      throw Exception("Pendapatan bulanan tidak boleh negatif.");
    }

    final userId = ref.read(authControllerProvider).valueOrNull?.userId;
    if (userId == null) {
      throw Exception("Sesi pengguna tidak valid.");
    }

    final isar = await ref.read(isarDatabaseProvider.future);

    final valuation = UserValuation()
      ..userId = userId
      ..monthlyIncome = monthlyIncome
      ..dailyWorkHours = dailyWorkHours;

    await isar.writeTxn(() async {
      await isar.userValuations.filter().userIdEqualTo(userId).deleteAll();
      await isar.userValuations.put(valuation);
    });

    final savedValuations = await isar.userValuations
        .filter()
        .userIdEqualTo(userId)
        .findAll();
    final savedValuation = _latestValuation(savedValuations);
    state = AsyncData(savedValuation ?? valuation);
  }

  UserValuation? _latestValuation(List<UserValuation> valuations) {
    if (valuations.isEmpty) return null;
    valuations.sort((a, b) => b.id.compareTo(a.id));
    return valuations.first;
  }
}
