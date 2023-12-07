class Guard {
  static String? nullValue(String? value, String name) {
    if (value == null) {
      return '$name is null';
    }
    return null;
  }

  static String? emptyString(String? value, String name) {
    final isNull = nullValue(value, name);
    if (isNull != null) {
      return isNull;
    }
    if (value!.isEmpty) {
      return '$name is empty';
    }
    return null;
  }

  static String? invalidEmail(String? value, String name) {
    final isEmpty = emptyString(value, name);
    if (isEmpty != null) {
      return isEmpty;
    }
    final RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regExp.hasMatch(value!)) {
      return '$name is invalid email format';
    }
    return null;
  }

  static String? invalidPassword(String? value, String name) {
    final isEmpty = emptyString(value, name);
    if (isEmpty != null) {
      return isEmpty;
    }

    if (value!.length < 5) {
      return '$name should at least have 5 characters';
    }
    return null;
  }

  static String? isNotMatch(String? value, String match, String name) {
    final isEmpty = emptyString(value, name);
    if (isEmpty != null) {
      return isEmpty;
    }

    if (value! != match) {
      return '$name does not match';
    }
    return null;
  }

  static String? validateTitle(String? value, String title) {
    if (title.isEmpty) {
      return "Title is required.";
    }

    if (title.length < 5) {
      return "Title should have at least 5 characters.";
    }

    if (title.length > 50) {
      return "Title should not exceed 50 characters.";
    }

    return null;
  }
}
