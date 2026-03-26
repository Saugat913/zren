import 'package:equatable/equatable.dart';

import 'form_validator.dart';

/// Represents the state of a form field with type-safe value tracking.
class FormFieldState<T> extends Equatable {
  /// Creates a form field state with an initial value.
  /// The [oldValue] is automatically set to the initial value for dirty tracking.
  const FormFieldState(
    this.value, {
    this.error,
    this.touched = false,
    this.validators = const [],
  }) : oldValue = value;

  /// Internal constructor for copyWith to preserve oldValue.
  const FormFieldState._(
    this.value,
    this.oldValue, {
    this.error,
    this.touched = false,
    this.validators = const [],
  });

  final T value;
  final T oldValue;
  final String? error;
  final bool touched;
  final List<Validator<T>> validators;

  /// Returns true if the current value differs from the initial value.
  bool get isDirty => value != oldValue;

  /// Returns true if the field has no validation error.
  bool get isValid => error == null;

  /// Returns true if the field has a validation error.
  bool get isInvalid => error != null;

  /// Validates the field using its validators and returns a new state.
  FormFieldState<T> validate() {
    String? error;
    for (final validator in validators) {
      error = validator(value);
      if (error != null) break;
    }
    return copyWith(error: error);
  }

  /// Creates a copy of this state with the given fields replaced.
  /// The [oldValue] is always preserved from the original state.
  FormFieldState<T> copyWith({
    T? value,
    String? error,
    bool? touched,
  }) {
    return FormFieldState<T>._(
      value ?? this.value,
      oldValue, // Preserve original oldValue for dirty tracking
      error: error,
      touched: touched ?? this.touched,
      validators: validators,
    );
  }

  @override
  List<Object?> get props => [value, oldValue, error, touched, validators];

  @override
  String toString() =>
      'FormFieldState(value: $value, oldValue: $oldValue, error: $error, touched: $touched, isDirty: $isDirty)';
}
