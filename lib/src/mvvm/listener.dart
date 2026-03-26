import 'package:flutter/widgets.dart';
import 'package:zren/src/mvvm/base_effect.dart';
import 'package:zren/src/mvvm/base_state.dart';
import 'package:zren/src/mvvm/consumer.dart';
import 'package:zren/src/mvvm/controller.dart';

class ZrenListener<
  C extends ZrenController<S, E>,
  S extends BaseState,
  E extends BaseEffect
>
    extends StatelessWidget {
  const ZrenListener({
    super.key,
    required this.child,
    required this.listener,
  });
  final Widget child;
  final void Function(BuildContext context, E effect) listener;

  @override
  Widget build(BuildContext context) {
    return ZrenConsumer<C, S, E>(
      buildWhen: (prev, curr) => false,
      listener: listener,
      builder: (context, state, controller) {
        return child;
      },
    );
  }
}
