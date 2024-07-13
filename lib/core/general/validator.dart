class BValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the above field.';
    }
    return null;
  }
  
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    //regular expression for email validation

    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Check for the minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    // Check for at least one uppercase letter using a regular expression
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one digit using a regular expression
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // If all conditions are met, return null to indicate a valid password
    return null;
  }

  static String? validateNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required';
    }
    RegExp phoneNo = RegExp(r"^[6789]\d{9}$");

    if (!phoneNo.hasMatch(phoneNumber)) {
      return 'Enter a 10-digit valid number';
    }

    for (int i = 0; i < phoneNumber.length - 4; i++) {
      if (phoneNumber[i] == phoneNumber[i + 1] &&
          phoneNumber[i + 1] == phoneNumber[i + 2] &&
          phoneNumber[i + 2] == phoneNumber[i + 3] &&
          phoneNumber[i + 3] == phoneNumber[i + 4]) {
        return 'Number has repetation ,enter valid number';
      }
    }

    return null;
  }
}
