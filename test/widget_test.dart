import 'package:flutter_test/flutter_test.dart';

import 'package:free_ai/main.dart';

void main() {
  testWidgets('dashboard loads with network chart selected', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('AI Charts Dashboard'), findsOneWidget);
    expect(find.text('Network Chart'), findsWidgets);
    expect(find.text('Interactive Network'), findsOneWidget);
  });
}
