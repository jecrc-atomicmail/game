import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('basic scaffold builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Stone Paper Scissors')),
        ),
      ),
    );

    expect(find.text('Stone Paper Scissors'), findsOneWidget);
  });
}
