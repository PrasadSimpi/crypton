import 'package:crypton/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash plays, then hands over to sign in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CryptonApp()));
    await tester.pump();

    expect(find.text('CRYPTON'), findsWidgets);

    // The intro runs for three seconds, then routes on.
    await tester.pump(const Duration(milliseconds: 3200));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
