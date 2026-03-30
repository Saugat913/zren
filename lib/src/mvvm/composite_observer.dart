import 'package:zren/mvvm.dart';

class CompositeObserver extends ZrenObserver {
  final List<ZrenObserver> _observers;

  const CompositeObserver(this._observers);

  @override
  void onCreate(ZrenController controller) {
    for (final o in _observers) {
      o.onCreate(controller);
    }
  }

  @override
  void onChange(ZrenController controller, ZrenChange change) {
    for (final o in _observers) {
      o.onChange(controller, change);
    }
  }

  @override
  void onEffect(ZrenController controller, BaseEffect effect) {
    for (final o in _observers) {
      o.onEffect(controller, effect);
    }
  }

  @override
  void onError(ZrenController controller, Object error, StackTrace stackTrace) {
    for (final o in _observers) {
      o.onError(controller, error, stackTrace);
    }
  }

  @override
  void onDispose(ZrenController controller) {
    for (final o in _observers) {
      o.onDispose(controller);
    }
  }
}