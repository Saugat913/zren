import 'package:flutter/cupertino.dart';
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
    this.listenWhen,
  });
  final Widget child;
  final void Function(BuildContext context, E effect) listener;
  final bool Function(S prev, S curr)? listenWhen;

  @override
  Widget build(BuildContext context) {
    return ZrenConsumer<C, S, E>(
      buildWhen: (prev, curr) => false,
      listener: listener,
      listenWhen: listenWhen,
      builder: (context, state, controller) {
        return child;
      },
    );
  }
}
