class BValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill the above field.';
    }
    return null;
  }
}
