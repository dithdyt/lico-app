import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lico/features/valuation/providers/valuation_provider.dart';

part 'calculator_provider.g.dart';

class CalculatorState {
  final String itemName;
  final double itemPrice;
  final bool isPaylater;
  final int months;
  final double interestRate;
  final double timeCostInHours;

  CalculatorState({
    this.itemName = '',
    this.itemPrice = 0,
    this.isPaylater = false,
    this.months = 1,
    this.interestRate = 0,
    this.timeCostInHours = 0,
  });

  CalculatorState copyWith({
    String? itemName,
    double? itemPrice,
    bool? isPaylater,
    int? months,
    double? interestRate,
    double? timeCostInHours,
  }) {
    return CalculatorState(
      itemName: itemName ?? this.itemName,
      itemPrice: itemPrice ?? this.itemPrice,
      isPaylater: isPaylater ?? this.isPaylater,
      months: months ?? this.months,
      interestRate: interestRate ?? this.interestRate,
      timeCostInHours: timeCostInHours ?? this.timeCostInHours,
    );
  }
}

@riverpod
class CalculatorNotifier extends _$CalculatorNotifier {
  @override
  CalculatorState build() {
    return CalculatorState();
  }

  void updateItemName(String name) => state = state.copyWith(itemName: name);
  void updateItemPrice(double price) => state = state.copyWith(itemPrice: price);
  void togglePaylater(bool value) => state = state.copyWith(isPaylater: value);
  void updateMonths(int months) => state = state.copyWith(months: months);
  void updateInterest(double rate) => state = state.copyWith(interestRate: rate);

  void reset() {
    state = CalculatorState();
  }

  void calculate() {
    final valuationAsync = ref.read(valuationNotifierProvider);
    final valuation = valuationAsync.value;
    
    if (valuation == null) return;

    final hourlyRate = valuation.hourlyRate;
    if (hourlyRate <= 0) return;

    double finalPrice = state.itemPrice;
    if (state.isPaylater) {
      // FSD Bab 3: totalPrice = itemPrice + (itemPrice * (interestRatePercentage / 100))
      finalPrice = state.itemPrice + (state.itemPrice * (state.interestRate / 100));
    }

    final timeCost = finalPrice / hourlyRate;
    state = state.copyWith(timeCostInHours: timeCost);
  }
}
