// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:application/main.dart';

void main() {
  testWidgets('renders home screen and navigates to diary tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TypingApp());
    await tester.pumpAndSettle();

    expect(find.text('안녕하세요, Hana'), findsOneWidget);

    await tester.tap(find.text('日記'));
    await tester.pumpAndSettle();

    expect(find.text('📝 日記'), findsOneWidget);
  });
}
