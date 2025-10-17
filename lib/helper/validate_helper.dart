import 'package:flutter/material.dart';

class ValidateHelper {
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 8) {
      return "Password Should be greater or equal 8";
    }
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return "Password must contain at least one uppercase letter";
    }
    if (!hasLowercase) {
      return "Password must contain at least one lowercase letter";
    }
    if (!hasDigit) {
      return "Password must contain at least one Number";
    }
    if (!hasSpecialChar) {
      return "Password must contain at least one special character";
    }

    return null;
  }

  static String? validateConfPassword({
    required String newPassword,
    required String confPassword,
  }) {
    if (confPassword.isEmpty) {
      return "Confirm Password is required";
    } else if (newPassword.characters == confPassword.characters) {
      return null;
    } else {
      return "Passwords don't match";
    }
  }

  static String? validateNormalString(String? text) {
    if (text == null || text.isEmpty) {
      return "field is required";
    }
    return null;
  }

  static String? validateNormalNumber(String? text) {
    if (text?.isEmpty ?? true) {
      return "Please enter a number";
    }
    if (num.tryParse(text!) == null) {
      return "Please enter a valid number";
    }
    return null;
  }

  static String? validateNormalFilterNumber(String? text) {
    if (num.tryParse(text!) == null) {
      return "Please enter a valid number";
    }
    return null;
  }

  static String? validateDropDown(dynamic value) {
    return value == null ? "Select one" : null;
  }

  static String? validatePhoneOptional(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return "Phone field is required";
    } else {
      return null;
    }
  }

  static validateFullName(String? name) {
    if (name == null) return "Full name is required";
    if (name.trim().isEmpty) {
      return "Full name is required";
    }
    return null;
  }

  static validateEmail(String? email) {
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)$",
    );
    if (email!.trim().isEmpty) {
      return "Email is required";
    } else if (!emailRegExp.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }
}
