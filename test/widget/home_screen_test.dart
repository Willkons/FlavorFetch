import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flavor_fetch/presentation/screens/home/home_screen.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('should display app title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.text('FlavorFetch'), findsOneWidget);
    });

    testWidgets('should display welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.text('Welcome to FlavorFetch!'), findsOneWidget);
      expect(
        find.text('Track your pet\'s food preferences'),
        findsOneWidget,
      );
    });

    testWidgets('should display placeholder buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.text('Pet Management'), findsOneWidget);
      expect(find.text('Scan Barcode'), findsOneWidget);
      expect(find.text('Feeding Logs'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
    });

    testWidgets('should show snackbar when button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Tap the Pet Management button
      await tester.tap(find.text('Pet Management'));
      await tester.pump();

      // Wait for snackbar animation
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text('Pet Management - Coming in future sprints'),
        findsOneWidget,
      );
    });

    testWidgets('should display pet icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.byIcon(Icons.pets), findsWidgets);
    });
  });
}
