import 'package:flutter/widgets.dart' hide FormFieldState;
import 'package:zren/src/form/form_controller.dart';
import 'package:zren/src/form/form_field_key.dart';
import 'package:zren/src/form/form_field_state.dart';
import 'package:zren/src/form/form_validator.dart';
import 'form_field_controller.dart';

/// Builds a form field with reactive state updates.
class FormFieldBuilder<T> extends StatefulWidget {
  const FormFieldBuilder({
    super.key,
    required this.formController,
    required this.fieldKey,
    required this.initialValue,
    required this.builder,
    this.validators = const [],
  });

  final FormController formController;
  final FormFieldKey<T> fieldKey;
  final T initialValue;
  final List<Validator<T>> validators;
  final Widget Function(FormFieldState<T> state, FormFieldController<T> controller) builder;

  @override
  State<FormFieldBuilder<T>> createState() => _FormFieldBuilderState<T>();
}

class _FormFieldBuilderState<T> extends State<FormFieldBuilder<T>> {
  late FormFieldController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.formController.register(
      widget.fieldKey,
      widget.initialValue,
      validators: widget.validators,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller.state,
      builder: (context, value, _) {
        return widget.builder(value, _controller);
      },
    );
  }
}
