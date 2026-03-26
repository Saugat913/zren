import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zren/src/mvvm/base_effect.dart';
import 'package:zren/src/mvvm/base_state.dart';
import 'package:zren/src/mvvm/controller.dart';
import 'package:zren/src/mvvm/provider.dart';

class ZrenConsumer<
  C extends ZrenController<S, E>,
  S extends BaseState,
  E extends BaseEffect
>
    extends StatefulWidget {
  const ZrenConsumer({
    super.key,
    required this.builder,
    this.buildWhen,
    this.listener,
  });
  final bool Function(S prev, S curr)? buildWhen;
  final void Function(BuildContext context, E effect)? listener;
  final Widget Function(BuildContext context, S state, C controller) builder;
  @override
  State<ZrenConsumer<C, S, E>> createState() => _ZrenConsumerState<C, S, E>();
}

class _ZrenConsumerState<
  C extends ZrenController<S, E>,
  S extends BaseState,
  E extends BaseEffect
>
    extends State<ZrenConsumer<C, S, E>> {
  late C controller;
  late StreamSubscription<E> baseEffectStream;

  void _controllerStateListener() {
    if (widget.buildWhen?.call(controller.prevState, controller.state) ??
        true) {
      if (mounted) setState(() {});
    }
  }

  void _controllerEffectListener(E effect) {
      if (!mounted) return;
      widget.listener?.call(context, effect);
  }

  @override
  void initState() {
    super.initState();
    final provider = ZrenProvider.of<C>(context);
    controller = provider;
    controller.addListener(_controllerStateListener);
    baseEffectStream = controller.effectStream.listen(
      _controllerEffectListener,
    );
  }

  @override
  void didUpdateWidget(ZrenConsumer<C, S, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newController = ZrenProvider.of<C>(context);
    if (newController != controller) {
      controller.removeListener(_controllerStateListener);
      baseEffectStream.cancel();
      controller = newController;
      controller.addListener(_controllerStateListener);
      baseEffectStream = controller.effectStream.listen(
        _controllerEffectListener,
      );
    }
  }

  @override
  void dispose() {
    baseEffectStream.cancel();
    controller.removeListener(_controllerStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, controller.state, controller);
  }
}
