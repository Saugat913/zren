import 'package:flutter/foundation.dart';
import 'package:zren/src/form/form_field_controller.dart';
import 'package:zren/src/form/form_field_state.dart';

class FormController extends ChangeNotifier {
  final _fields = <String, FormFieldController<dynamic>>{};

  FormFieldController<T> register<T>(String name, T initialValue) {
    if (_fields.containsKey(name)) {
      return _fields[name]! as FormFieldController<T>;
    }

    final controller = FormFieldController<T>(FormFieldState<T>(initialValue));

    _fields[name] = controller;

    return controller;
  }

  bool validate() {
    for (final controller in _fields.values) {
      controller.validate();
    }
    return _fields.values.every(
      (controller) => controller.state.value.error?.isEmpty ?? false,
    );
  }

  @override
  void dispose() {
    _fields.clear();
    super.dispose();
  }
}
