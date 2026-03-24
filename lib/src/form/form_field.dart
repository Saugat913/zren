import 'package:flutter/widgets.dart' hide FormFieldState;
import 'package:zren/src/form/form_controller.dart';
import 'package:zren/src/form/form_field_state.dart';
import 'form_field_controller.dart';

class FormFieldBuilder<T> extends StatefulWidget {
  const FormFieldBuilder({
    super.key,
    required this.formController,
    required this.name,
    required this.initialValue,
    required this.builder,
  });
  final FormController formController;
  final String name;
  final T initialValue;
  final Widget Function(FormFieldState<T> state) builder;

  @override
  State<FormFieldBuilder<T>> createState() => _FormFieldBuilderState<T>();
}

class _FormFieldBuilderState<T> extends State<FormFieldBuilder<T>> {
  late FormFieldController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.formController.register(
      widget.name,
      widget.initialValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller.state,
      builder: (context, value, _) {
        return widget.builder(value);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
