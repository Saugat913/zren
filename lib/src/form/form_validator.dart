typedef Validator<T> = String? Function(T value);

class Validators {
  static Validator<String> required([String message = 'Required']) {
    return (value) {
      if (value.isEmpty) return message;
      return null;
    };
  }

  static Validator<String> minLength(int length) {
    return (value) {
      if (value.length < length) {
        return 'Min $length characters';
      }
      return null;
    };
  }

  static Validator<String> email() {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return (value) {
      if (!regex.hasMatch(value)) {
        return 'Invalid email';
      }
      return null;
    };
  }
}
