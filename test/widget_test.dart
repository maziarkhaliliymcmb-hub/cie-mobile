import 'package:flutter_test/flutter_test.dart';
import 'package:cie_mobile/main.dart';

void main() {
  testWidgets('dashboard renders and navigation switches sections',
      (tester) async {
    await tester.pumpWidget(const CieMobileApp());

    expect(find.text('CIE Mobile'), findsOneWidget);
    expect(find.text('مرکز فرماندهی'), findsOneWidget);

    await tester.tap(find.text('عامل‌ها'));
    await tester.pumpAndSettle();

    expect(find.text('عامل‌های هوشمند'), findsOneWidget);
  });
}
