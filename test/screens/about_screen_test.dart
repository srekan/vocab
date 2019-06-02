import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/screens/about_screen.dart';

void main() {
  group('About Screen', () {
    testWidgets('Should have a title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AboutScreen(),
        ),
      );
      final titleFinder = find.text('About');
      expect(titleFinder, findsOneWidget);

      final contentTitleFinder = find.text('Vocab by English House');
      expect(contentTitleFinder, findsOneWidget);
    });
  });
}
