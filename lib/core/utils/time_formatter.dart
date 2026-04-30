class TimeFormatter {
  static String formatHours(double hours) {
    if (hours < 1) {
      final minutes = (hours * 60).round();
      return "$minutes Menit";
    }
    
    if (hours < 24) {
      final h = hours.floor();
      final m = ((hours - h) * 60).round();
      if (m == 0) return "$h Jam";
      return "$h Jam $m Menit";
    }
    
    final days = (hours / 24).floor();
    final remainingHours = (hours % 24).round();
    if (remainingHours == 0) return "$days Hari";
    return "$days Hari $remainingHours Jam";
  }
}
