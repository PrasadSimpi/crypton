import 'package:crypton/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Formatters.group', () {
    test('inserts separators every three digits', () {
      expect(Formatters.group('41812'), '41,812');
      expect(Formatters.group('100'), '100');
      expect(Formatters.group('1234567'), '1,234,567');
    });
  });

  group('Formatters.moneyParts', () {
    test('splits the whole part from the cents', () {
      final parts = Formatters.moneyParts(41812.14);
      expect(parts.whole, r'$41,812');
      expect(parts.fraction, '.14');
    });

    test('uses a true minus sign for negatives', () {
      expect(Formatters.moneyParts(-12.5).whole, '−\$12');
    });
  });

  group('Formatters.signedPercent', () {
    test('always carries a sign', () {
      expect(Formatters.signedPercent(3.17), '+3.17%');
      expect(Formatters.signedPercent(-3.42), '−3.42%');
      expect(Formatters.signedPercent(0), '+0.00%');
    });
  });

  group('Formatters.compact', () {
    test('picks a suffix and adapts precision', () {
      expect(Formatters.compact(1.32e12), '1.32T');
      expect(Formatters.compact(28.4e9), '28.4B');
    });

    test('honours a pinned precision', () {
      expect(Formatters.compact(19.74e6, decimals: 2), '19.74M');
    });
  });

  group('Formatters.quantity', () {
    test('groups the whole part and keeps the asset precision', () {
      expect(Formatters.quantity(2521.9, decimals: 1), '2,521.9');
      expect(Formatters.quantity(0.4215), '0.4215');
    });
  });
}
