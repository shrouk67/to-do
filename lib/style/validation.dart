class Validation {
  static String? fullNameValidator(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    String? result = fullNameValidator(value, 'should enter your email');
    if (result == null) {
      if (!isValidEmail(value!)) {
        result = 'Email is not valid';
      }
    }
    return result;
  }

  static bool isValidEmail(String email) {
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
    return emailValid;
  }
}
