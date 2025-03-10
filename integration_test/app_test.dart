import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movies_tmdb/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Movie list and detail navigation', (WidgetTester tester) async {
    // Pump the app and wait for the initial state
    await tester.pumpWidget(const MyApp());
    await tester
        .pumpAndSettle(const Duration(seconds: 2)); // Wait for initial load

    // Verify the movie list is displayed
    expect(find.text('Movies'), findsOneWidget);

    // Ensure at least one movie card is present
    expect(find.byType(Card), findsWidgets);

    // Tap on the first movie card
    await tester.tap(find.byType(Card).first);
    await tester.pumpAndSettle();

    // Verify the detail screen is displayed
    expect(find.text('Movie Details'), findsOneWidget);

    // Find and tap the favorite button (use a more specific finder)
    final favoriteIconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is IconButton &&
          (widget.icon as Icon).icon == Icons.favorite_border,
    );
    expect(favoriteIconFinder, findsOneWidget); // Verify it exists
    await tester.tap(favoriteIconFinder);
    await tester.pumpAndSettle();

    // Verify the favorite icon changes to filled
    final filledFavoriteIconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is IconButton && (widget.icon as Icon).icon == Icons.favorite,
    );
    expect(filledFavoriteIconFinder, findsOneWidget);

    // Go back to the list
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify the favorite icon is updated in the list
    expect(filledFavoriteIconFinder, findsWidgets); // Should find at least one
  });
}
