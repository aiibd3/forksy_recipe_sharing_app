class RegexManager {
  static bool isPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r"^(010|012|011|015)\d{8}$");
    return regex.hasMatch(phoneNumber);
  }

  static bool isEmail(String email) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return regex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    RegExp regex = RegExp(r'^.{6,}$');
    return regex.hasMatch(password);
  }
}
