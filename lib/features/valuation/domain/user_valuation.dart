import 'package:isar/isar.dart';

part 'user_valuation.g.dart';

@collection
class UserValuation {
  Id id = Isar.autoIncrement;

  double monthlyIncome = 0;
  double weeklyWorkHours = 0;

  double get monthlyWorkHours => weeklyWorkHours * 4;

  double get hourlyRate {
    if (monthlyWorkHours == 0) return 0;
    return monthlyIncome / monthlyWorkHours;
  }
}
