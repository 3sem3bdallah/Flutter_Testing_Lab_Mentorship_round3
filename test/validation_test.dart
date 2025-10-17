import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/helper/validate_helper.dart';

void main() {
  group("Testing 'validate_helper' methods", () {
    test('Full name is required', () {
      expect(ValidateHelper.validateFullName(''), 'Full name is required');
    });

    test('Full name should be valid', () {
      expect(ValidateHelper.validateFullName('Fatma Ahmed'), null);
    });

    test('Email is required', () {
      expect(ValidateHelper.validateEmail(''), 'Email is required');
    });

    test('Email should be valid', () {
      expect(ValidateHelper.validateEmail('test@example.com'), null);
    });

    test('Email should be invalid', () {
      expect(
        ValidateHelper.validateEmail('invalid_email'),
        'Please enter a valid email',
      );
    });

    test('Password should not be empty', () {
      expect(ValidateHelper.validatePassword(''), 'Password is required');
    });

    test('Password should be strong', () {
      expect(
        ValidateHelper.validatePassword('123'),
        'Password Should be greater or equal 8',
      );
    });

    test('Password should be valid', () {
      expect(ValidateHelper.validatePassword('Test@1234'), null);
    });

    test('Confirm password should match', () {
      expect(
        ValidateHelper.validateConfPassword(
          newPassword: 'Test@1234',
          confPassword: 'Test@1234',
        ),
        null,
      );
    });

    test('Confirm password should fail if not matching', () {
      expect(
        ValidateHelper.validateConfPassword(
          newPassword: 'Test@1234',
          confPassword: 'WrongPass',
        ),
        'Passwords don\'t match',
      );
    });
  });
}
