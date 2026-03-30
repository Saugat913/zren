import 'package:zren/src/mvvm/base_effect.dart';
import 'package:zren/src/mvvm/base_state.dart';
import 'controller.dart';

class ZrenChange<S extends BaseState> {
  final S currentState;
  final S nextState;
  const ZrenChange({required this.currentState, required this.nextState});

  @override
  String toString() =>
      'ZrenChange { current: $currentState, next: $nextState }';
}

abstract class ZrenObserver {
  const ZrenObserver();

  void onCreate(ZrenController controller) {}

  void onChange(ZrenController controller, ZrenChange change) {}

  void onEffect(ZrenController controller, BaseEffect effect) {}

  void onError(ZrenController controller, Object error, StackTrace stackTrace) {}

  void onDispose(ZrenController controller) {}
}

class Zren {
  Zren._();

  static ZrenObserver _observer = const _NoOpObserver();

  static ZrenObserver get observer => _observer;

  /// Call this in main() before runApp().
  static void initialize(ZrenObserver observer) {
    _observer = observer;
  }
}

class _NoOpObserver extends ZrenObserver {
  const _NoOpObserver();
}