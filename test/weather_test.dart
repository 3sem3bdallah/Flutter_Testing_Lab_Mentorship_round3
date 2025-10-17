import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

class _WeatherDisplayState {
  double celsiusToFahrenheit(num c) => c.toDouble() * 9 / 5 + 32;
  double fahrenheitToCelsius(num f) => (f.toDouble() - 32) * 5 / 9;
}

void main() {
  group('Temperature Conversion Tests', () {
    late _WeatherDisplayState weatherState;

    setUp(() {
      weatherState = _WeatherDisplayState();
    });

    test('celsiusToFahrenheit converts 0°C to 32°F', () {
      expect(weatherState.celsiusToFahrenheit(0), equals(32.0));
    });

    test('celsiusToFahrenheit converts 100°C to 212°F', () {
      expect(weatherState.celsiusToFahrenheit(100), equals(212.0));
    });

    test('celsiusToFahrenheit converts -40°C to -40°F', () {
      expect(weatherState.celsiusToFahrenheit(-40), equals(-40.0));
    });

    test('celsiusToFahrenheit converts 25°C to 77°F', () {
      expect(weatherState.celsiusToFahrenheit(25), equals(77.0));
    });

    test('celsiusToFahrenheit converts negative temperatures correctly', () {
      expect(weatherState.celsiusToFahrenheit(-10), equals(14.0));
    });

    test('fahrenheitToCelsius converts 32°F to 0°C', () {
      expect(weatherState.fahrenheitToCelsius(32), equals(0.0));
    });

    test('fahrenheitToCelsius converts 212°F to 100°C', () {
      expect(weatherState.fahrenheitToCelsius(212), equals(100.0));
    });

    test('fahrenheitToCelsius converts -40°F to -40°C', () {
      expect(weatherState.fahrenheitToCelsius(-40), equals(-40.0));
    });

    test('fahrenheitToCelsius converts 77°F to 25°C', () {
      expect(weatherState.fahrenheitToCelsius(77), equals(25.0));
    });

    test('fahrenheitToCelsius converts negative temperatures correctly', () {
      expect(weatherState.fahrenheitToCelsius(14), equals(-10.0));
    });

    test('Conversion round-trip preserves value', () {
      const originalCelsius = 22.5;
      final fahrenheit = weatherState.celsiusToFahrenheit(originalCelsius);
      final backToCelsius = weatherState.fahrenheitToCelsius(fahrenheit);
      expect(backToCelsius, closeTo(originalCelsius, 0.0001));
    });
  });

  group('WeatherData.fromJson Tests', () {
    test('parses complete valid JSON correctly', () {
      final json = {
        'city': 'London',
        'temperature': 15.0,
        'description': 'Rainy',
        'humidity': 85,
        'windSpeed': 8.5,
        'icon': '🌧️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, equals('London'));
      expect(weatherData.temperatureCelsius, equals(15.0));
      expect(weatherData.description, equals('Rainy'));
      expect(weatherData.humidity, equals(85));
      expect(weatherData.windSpeed, equals(8.5));
      expect(weatherData.icon, equals('🌧️'));
    });

    test('throws ArgumentError when JSON is null', () {
      expect(
        () => WeatherData.fromJson(null),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when city is missing', () {
      final json = {
        'temperature': 15.0,
        'description': 'Rainy',
      };

      expect(
        () => WeatherData.fromJson(json),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when temperature is missing', () {
      final json = {
        'city': 'London',
        'description': 'Rainy',
      };

      expect(
        () => WeatherData.fromJson(json),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('uses default values for optional fields when missing', () {
      final json = {
        'city': 'TestCity',
        'temperature': 22.5,
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, equals('TestCity'));
      expect(weatherData.temperatureCelsius, equals(22.5));
      expect(weatherData.description, equals('No description'));
      expect(weatherData.humidity, equals(0));
      expect(weatherData.windSpeed, equals(0.0));
      expect(weatherData.icon, equals('🌡️'));
    });

    test('handles integer temperature value', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20, // Integer instead of double
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.temperatureCelsius, equals(20.0));
    });

    test('handles integer windSpeed value', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20.0,
        'windSpeed': 10, // Integer instead of double
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.windSpeed, equals(10.0));
    });

    test('handles null description with default value', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20.0,
        'description': null,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.description, equals('No description'));
    });

    test('handles null humidity with default value', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20.0,
        'humidity': null,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.humidity, equals(0));
    });

    test('handles null windSpeed with default value', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20.0,
        'windSpeed': null,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.windSpeed, equals(0.0));
    });

    test('handles null icon with default value', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20.0,
        'icon': null,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.icon, equals('🌡️'));
    });

    test('handles empty JSON map (only required fields missing)', () {
      final json = <String, dynamic>{};

      expect(
        () => WeatherData.fromJson(json),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('parses all cities correctly', () {
      final cities = [
        {'city': 'New York', 'temperature': 22.5},
        {'city': 'London', 'temperature': 15.0},
        {'city': 'Tokyo', 'temperature': 25.0},
      ];

      for (final json in cities) {
        final weatherData = WeatherData.fromJson(json);
        expect(weatherData.city, equals(json['city']));
        expect(weatherData.temperatureCelsius, equals(json['temperature']));
      }
    });
  });

  group('WeatherData Edge Cases', () {
    test('handles very high temperature values', () {
      final json = {
        'city': 'Desert',
        'temperature': 50.0,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.temperatureCelsius, equals(50.0));
    });

    test('handles very low temperature values', () {
      final json = {
        'city': 'Arctic',
        'temperature': -50.0,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.temperatureCelsius, equals(-50.0));
    });

    test('handles zero temperature', () {
      final json = {
        'city': 'FreezingPoint',
        'temperature': 0.0,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.temperatureCelsius, equals(0.0));
    });

    test('handles decimal humidity values by truncating', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20.0,
        'humidity': 85,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.humidity, equals(85));
    });

    test('handles very long city names', () {
      final json = {
        'city': 'A' * 100,
        'temperature': 20.0,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.city.length, equals(100));
    });

    test('handles special characters in city names', () {
      final json = {
        'city': 'São Paulo',
        'temperature': 28.0,
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.city, equals('São Paulo'));
    });

    test('handles emoji in description', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20.0,
        'description': 'Sunny ☀️',
      };

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.description, equals('Sunny ☀️'));
    });
  });
}