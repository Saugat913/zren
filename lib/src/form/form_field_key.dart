/// A type-safe key for form fields that ensures compile-time type checking.
///
/// Use [FormFieldKey] to define fields once and get type-safe access throughout your form.
///
/// ```dart
/// class LoginFormFields {
///   static const email = FormFieldKey<String>('email');
///   static const age = FormFieldKey<int>('age');
///   static const subscribe = FormFieldKey<bool>('subscribe');
/// }
/// ```
class FormFieldKey<T> {
  const FormFieldKey(this.name);

  /// The unique name of the field.
  final String name;

  @override
  String toString() => 'FormFieldKey<$T>("$name")';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormFieldKey<T> &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
