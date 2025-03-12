class Validators  {
  // Email Validation
  static String? emailValidator(String value) {
    return null;
  }

  // Password Validation
  static String? passwordValidator(String value) {
    if (value.isEmpty) {
      return "Password cannot be empty";
    }
    final passwordRgx = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$');
    if (!passwordRgx.hasMatch(value)) {
      return "Password must contain at least one uppercase letter, one lowercase letter, and one number";
    }
    return null;
  }

  // Confirm Password Validation
  static String? confirmPasswordValidator(String value, String password) {
    if (value.isEmpty) {
      return "Confirm Password cannot be empty";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  // Username Validation
  static String? userNameValidator(String value) {
    if (value.isEmpty) {
      return "Username cannot be empty";
    }
    if (value.length < 4) {
      return "Username cannot be less than 4 characters";
    }
    return null;
  }

  // Location Validation
  static String? locationValidator(String value) {
    if (value.isEmpty) {
      return "Location cannot be empty";
    }
    return null;
  }
}
