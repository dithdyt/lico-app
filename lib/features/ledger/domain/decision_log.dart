import 'package:isar/isar.dart';

part 'decision_log.g.dart';

enum DecisionStatus {
  burned,
  saved,
}

@collection
class DecisionLog {
  Id id = Isar.autoIncrement;

  late String itemName;
  late double itemPrice;
  late double timeCostInHours;
  late bool isPaylater;

  @enumerated
  late DecisionStatus status;

  late DateTime createdAt;
}
