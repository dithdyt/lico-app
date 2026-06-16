class TimeFormatter {
  static String formatHours(double hours) {
    if (hours.isNaN || hours.isInfinite) return "0 Menit";

    final isNegative = hours < 0;
    final sign = isNegative ? "-" : "";
    final totalMinutes = (hours.abs() * 60).round();

    if (totalMinutes < 60) {
      return "$sign$totalMinutes Menit";
    }

    if (totalMinutes < 1440) {
      final h = totalMinutes ~/ 60;
      final m = totalMinutes % 60;
      if (m == 0) return "$sign$h Jam";
      return "$sign$h Jam $m Menit";
    }

    final days = totalMinutes ~/ 1440;
    final remainingHours = (totalMinutes % 1440) ~/ 60;
    if (remainingHours == 0) return "$sign$days Hari";
    return "$sign$days Hari $remainingHours Jam";
  }
}
