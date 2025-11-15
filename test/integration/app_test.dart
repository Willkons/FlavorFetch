import 'package:flutter_test/flutter_test.dart';
import 'package:flavor_fetch/app.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should launch app successfully', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const FlavorFetchApp());

      // Verify app launches and displays home screen
      expect(find.text('FlavorFetch'), findsOneWidget);
      expect(find.text('Welcome to FlavorFetch!'), findsOneWidget);
    });

    testWidgets('should apply theme correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const FlavorFetchApp());

      // Verify Material3 is being used
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
      expect(app.darkTheme?.useMaterial3, isTrue);
    });

    testWidgets('should handle navigation', (WidgetTester tester) async {
      await tester.pumpWidget(const FlavorFetchApp());

      // App starts successfully
      expect(find.text('FlavorFetch'), findsOneWidget);

      // TODO: Add navigation tests when more screens are implemented
    });
  });
}
