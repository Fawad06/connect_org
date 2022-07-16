import 'package:get/get.dart';

class Validators {
  static String? mobileNumberValidator(String? value, {bool optional = false}) {
    if (value == null || value.isEmpty) {
      if (!optional) {
        return "This field is required";
      } else {
        return null;
      }
    } else if (!GetUtils.isPhoneNumber(value)) {
      return "Enter a valid phone number";
    } else {
      return null;
    }
  }

  static String? nameValidator(String? value, {bool optional = false}) {
    if (value == null || value.isEmpty) {
      if (optional) {
        return null;
      } else {
        return "This field is required";
      }
    } else if (value.length < 3) {
      return "At least 2 characters required.";
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? value, {bool optional = false}) {
    if (value == null || value.isEmpty) {
      if (optional) {
        return null;
      } else {
        return "This field is required";
      }
    } else if (value.length < 6) {
      return "Password too short";
    } else if (!RegExp(
            r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")
        .hasMatch(value)) {
      return "Password must contain a number,letter \nand a special character.";
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "This field is required";
    } else if (confirmPassword != password) {
      return "Password do not match";
    } else {
      return null;
    }
  }

  static String? usernameValidator(String? value, {bool optional = false}) {
    if (value == null || value.isEmpty) {
      if (optional) {
        return null;
      } else {
        return "This field is required";
      }
    } else if (!GetUtils.isUsername(value)) {
      return "Enter a valid username.";
    } else {
      return null;
    }
  }

  static String? emailValidator(String? value, {bool optional = false}) {
    if (value == null || value.isEmpty) {
      if (optional) {
        return null;
      } else {
        return "This field is required";
      }
    } else if (!GetUtils.isEmail(value)) {
      return "Enter a valid email.";
    } else {
      return null;
    }
  }
}
