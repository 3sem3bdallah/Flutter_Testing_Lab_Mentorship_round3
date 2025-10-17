import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('WeatherDisplay Widget Tests', () {
    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays city dropdown with all cities', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.byType(DropdownButton<String>), findsOneWidget);
      
      // Tap dropdown to open it
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Verify all cities are present
      expect(find.text('New York'), findsWidgets);
      expect(find.text('London'), findsWidgets);
      expect(find.text('Tokyo'), findsWidgets);
      expect(find.text('Invalid City'), findsWidgets);
    });

    testWidgets('displays temperature unit toggle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.text('Temperature Unit:'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Celsius'), findsOneWidget);
    });

    testWidgets('toggles between Celsius and Fahrenheit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Initially shows Celsius
      expect(find.text('Celsius'), findsOneWidget);

      // Toggle switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Now shows Fahrenheit
      expect(find.text('Fahrenheit'), findsOneWidget);
      expect(find.text('Celsius'), findsNothing);

      // Toggle back
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(find.text('Celsius'), findsOneWidget);
      expect(find.text('Fahrenheit'), findsNothing);
    });

    testWidgets('displays refresh button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      expect(find.widgetWithText(ElevatedButton, 'Refresh'), findsOneWidget);
    });

    testWidgets('displays weather card after loading completes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for loading to complete (2 second delay in mock)
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display weather card
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('displays error message for Invalid City', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Select Invalid City
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      // Wait for loading to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display error
      expect(find.text('Error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Try Again'), findsOneWidget);
    });

    testWidgets('error card has correct styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Select Invalid City to trigger error
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Find the error card
      final card = tester.widget<Card>(find.byType(Card).first);
      expect(card.color, isNotNull);
    });

    testWidgets('can retry after error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Trigger error
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap Try Again
      await tester.tap(find.widgetWithText(ElevatedButton, 'Try Again'));
      await tester.pump();

      // Should show loading again
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('refresh button reloads weather', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap refresh
      await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh'));
      await tester.pump();

      // Should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('changing city triggers reload', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change city
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pump();

      // Should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays weather details when data is available', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check if weather details are displayed (humidity and wind speed)
      expect(find.text('Humidity'), findsOneWidget);
      expect(find.text('Wind Speed'), findsOneWidget);
      expect(find.byIcon(Icons.water_drop), findsOneWidget);
      expect(find.byIcon(Icons.air), findsOneWidget);
    });

    testWidgets('temperature display updates when toggling units', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Find temperature text in Celsius
      final celsiusText = find.textContaining('°C');
      expect(celsiusText, findsOneWidget);

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Should now show Fahrenheit
      final fahrenheitText = find.textContaining('°F');
      expect(fahrenheitText, findsOneWidget);
      expect(find.textContaining('°C'), findsNothing);
    });

    testWidgets('weather icon is displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check for weather icons (emojis)
      final iconFinder = find.byWidgetPredicate(
        (widget) => widget is Text && 
                    (widget.data?.contains('☀️') == true || 
                     widget.data?.contains('🌧️') == true || 
                     widget.data?.contains('☁️') == true),
      );
      expect(iconFinder, findsWidgets);
    });

    testWidgets('city name is displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display New York (default city)
      expect(find.text('New York'), findsWidgets);
    });

    testWidgets('weather description is displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display weather description (Sunny for New York)
      expect(find.text('Sunny'), findsOneWidget);
    });

    testWidgets('humidity percentage is displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display humidity with percentage
      final humidityFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data?.contains('%') == true,
      );
      expect(humidityFinder, findsWidgets);
    });

    testWidgets('wind speed is displayed with units', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display wind speed with km/h
      final windFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data?.contains('km/h') == true,
      );
      expect(windFinder, findsWidgets);
    });

    testWidgets('does not crash on incomplete data', (tester) async {
      // This test may randomly hit the incomplete data case
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should either show data or error, but not crash
      final hasData = find.byType(Card).evaluate().isNotEmpty;
      final hasError = find.text('Error').evaluate().isNotEmpty;
      
      expect(hasData || hasError, isTrue);
    });

    testWidgets('loading indicator disappears after data loads', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Initially loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for load to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Loading indicator should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('weather card has proper elevation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Find weather card (not error card)
      final cards = tester.widgetList<Card>(find.byType(Card));
      final weatherCard = cards.firstWhere(
        (card) => card.elevation == 4,
        orElse: () => cards.first,
      );
      
      expect(weatherCard.elevation, equals(4));
    });

    testWidgets('multiple rapid city changes do not cause errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Rapidly change cities
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('London').last);
        await tester.pump();
        
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Tokyo').last);
        await tester.pump();
      }

      // Should not crash
      expect(tester.takeException(), isNull);
    });

    testWidgets('widget maintains state during unit toggle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Get city before toggle
      expect(find.text('New York'), findsWidgets);

      // Toggle temperature unit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // City should still be the same
      expect(find.text('New York'), findsWidgets);
    });

    testWidgets('correct temperature conversion displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Select London (15°C)
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle();

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check Celsius display
      expect(find.text('15.0°C'), findsOneWidget);

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // 15°C = 59°F
      expect(find.text('59.0°F'), findsOneWidget);
    });

    testWidgets('UI elements are properly laid out', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check vertical spacing
      expect(find.byType(SizedBox), findsWidgets);
      
      // Check Row layouts
      expect(find.byType(Row), findsWidgets);
      
      // Check Column layout
      expect(find.byType(Column), findsWidgets);
    });
  });

  group('WeatherDisplay Integration Tests', () {
    testWidgets('complete user flow: select city, toggle units, refresh', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // 1. Initial load
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // 2. Change to London
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('London'), findsWidgets);

      // 3. Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(find.text('Fahrenheit'), findsOneWidget);

      // 4. Refresh
      await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should still show London in Fahrenheit
      expect(find.text('London'), findsWidgets);
      expect(find.text('Fahrenheit'), findsOneWidget);
    });

    testWidgets('error recovery flow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherDisplay(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Trigger error
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);

      // Recover by selecting valid city
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo').last);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show Tokyo weather
      expect(find.text('Tokyo'), findsWidgets);
      expect(find.text('Error'), findsNothing);
    });
  });
}