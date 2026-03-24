import 'package:equatable/equatable.dart';

import 'form_validator.dart';

class FormFieldState<T> extends Equatable {
  const FormFieldState(
    this.value, {
    this.error,
    this.touched = false,
    this.validators = const [],
  });
  final T value;
  final String? error;
  final bool touched;
  final List<Validator<T>> validators;

  FormFieldState<T> validate() {
    String? error;
    for (final validator in validators) {
      error = validator(value);
      if (error != null) break;
    }
    return copyWith(error: error);
  }

  FormFieldState<T> copyWith({
    T? value,
    String? error,
    bool clearError = false,
    bool? touched,
  }) {
    return FormFieldState<T>(
      value ?? this.value,
      error: error ?? (clearError ? null : this.error),
      validators: this.validators,
      touched: touched ?? this.touched,
    );
  }

  @override
  List<Object?> get props => [value, error, touched, validators];

  @override
  String toString() =>
      'FormFieldState(value:$value,error:$error,touched:$touched';
}
