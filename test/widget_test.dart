import 'package:flutter_test/flutter_test.dart';
import 'package:lico/core/utils/time_formatter.dart';

void main() {
  group('TimeFormatter', () {
    test('formats positive hours consistently', () {
      expect(TimeFormatter.formatHours(0.5), '30 Menit');
      expect(TimeFormatter.formatHours(1.5), '1 Jam 30 Menit');
      expect(TimeFormatter.formatHours(49), '2 Hari 1 Jam');
    });

    test('formats negative hours with the same units as positive hours', () {
      expect(TimeFormatter.formatHours(-0.5), '-30 Menit');
      expect(TimeFormatter.formatHours(-119.8), '-4 Hari 23 Jam');
      expect(TimeFormatter.formatHours(-119.4), '-4 Hari 23 Jam');
    });

    test('falls back safely for invalid numeric input', () {
      expect(TimeFormatter.formatHours(double.nan), '0 Menit');
      expect(TimeFormatter.formatHours(double.infinity), '0 Menit');
      expect(TimeFormatter.formatHours(double.negativeInfinity), '0 Menit');
    });
  });
}
