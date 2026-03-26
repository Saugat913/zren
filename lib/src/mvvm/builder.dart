import 'package:flutter/widgets.dart';
import 'package:zren/src/mvvm/base_effect.dart';
import 'package:zren/src/mvvm/base_state.dart';
import 'package:zren/src/mvvm/consumer.dart';
import 'package:zren/src/mvvm/controller.dart';

class ZrenBuilder<
  C extends ZrenController<S, E>,
  S extends BaseState,
  E extends BaseEffect
>
    extends StatelessWidget {
  const ZrenBuilder({super.key, required this.builder, this.buildWhen});
  final Widget Function(BuildContext context, S state, C controller) builder;
  final bool Function(S prev, S curr)? buildWhen;

  @override
  Widget build(BuildContext context) {
    return ZrenConsumer<C, S, E>(builder: builder, buildWhen: buildWhen);
  }
}
