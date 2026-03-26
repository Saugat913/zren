import 'package:flutter/foundation.dart';
import 'package:zren/src/form/form_field_controller.dart';
import 'package:zren/src/form/form_field_key.dart';
import 'package:zren/src/form/form_field_state.dart';
import 'package:zren/src/form/form_validator.dart';

/// Manages form fields with type-safe registration and value access.
class FormController extends ChangeNotifier {
  final _fields = <String, FormFieldController<dynamic>>{};

  /// Registers a field with a type-safe key.
  ///
  /// ```dart
  /// static const email = FormFieldKey<String>('email');
  /// controller.register(email, '');
  /// ```
  FormFieldController<T> register<T>(
    FormFieldKey<T> key,
    T initialValue, {
    List<Validator<T>> validators = const [],
  }) {
    final name = key.name;

    if (_fields.containsKey(name)) {
      final existing = _fields[name]!;
      if (existing is! FormFieldController<T>) {
        throw StateError(
          'Field "$name" already registered with different type. '
          'Expected FormFieldController<$T>, found ${existing.runtimeType}',
        );
      }
      return existing;
    }

    final controller = FormFieldController<T>(
      FormFieldState<T>(initialValue, validators: validators),
    );
    controller.state.addListener(notifyListeners);
    _fields[name] = controller;

    return controller;
  }

  /// Gets the typed value of a field.
  ///
  /// ```dart
  /// final email = controller.getValue(LoginFormFields.email);
  /// ```
  T getValue<T>(FormFieldKey<T> key) {
    final field = _fields[key.name];
    if (field == null) {
      throw StateError('Field "${key.name}" not found. Register it first.');
    }
    return (field as FormFieldController<T>).state.value.value;
  }

  /// Sets the value of a field.
  ///
  /// ```dart
  /// controller.setValue(LoginFormFields.email, 'test@example.com');
  /// ```
  void setValue<T>(FormFieldKey<T> key, T value) {
    final field = _fields[key.name];
    if (field == null) {
      throw StateError('Field "${key.name}" not found. Register it first.');
    }
    (field as FormFieldController<T>).setValue(value);
  }

  /// Gets all field values as a map.
  Map<String, dynamic> getValues() {
    return {
      for (final entry in _fields.entries)
        entry.key: entry.value.state.value.value,
    };
  }

  /// Validates all fields and returns true if all are valid.
  bool validate() {
    for (final controller in _fields.values) {
      controller.validate();
    }
    return _fields.values.every(
      (controller) => controller.state.value.isValid,
    );
  }

  /// Returns true if any field has been modified.
  bool get isDirty {
    return _fields.values.any(
      (c) => c.state.value.isDirty,
    );
  }

  /// Returns true if all fields are valid.
  bool get isValid {
    return _fields.values.every(
      (c) => c.state.value.isValid,
    );
  }

  void resetField<T>(FormFieldKey<T> key) {
    final field = _fields[key.name];
    if (field == null) {
      throw StateError('Field "${key.name}" not found.');
    }
    (field as FormFieldController<T>).reset();
  }

  void reset() {
    for (final controller in _fields.values) {
      controller.reset();
    }
  }
  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    _fields.clear();
    super.dispose();
  }
}
