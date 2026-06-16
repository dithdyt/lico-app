import 'package:isar/isar.dart';

part 'user_valuation.g.dart';

@collection
class UserValuation {
  Id id = Isar.autoIncrement;

  late String userId;
  double monthlyIncome = 0;
  double dailyWorkHours = 0;

  double get monthlyWorkHours => dailyWorkHours * 22;

  double get hourlyRate {
    if (monthlyWorkHours == 0) return 0;
    return monthlyIncome / monthlyWorkHours;
  }
}
