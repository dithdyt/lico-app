import 'package:isar/isar.dart';

part 'user_valuation.g.dart';

@collection
class UserValuation {
  Id id = Isar.autoIncrement;

  double monthlyIncome = 0;
  double weeklyWorkHours = 0;

  @ignore
  double get hourlyRate {
    if (weeklyWorkHours <= 0) return 0;
    final monthlyWorkHours = weeklyWorkHours * 4;
    return monthlyIncome / monthlyWorkHours;
  }
}
