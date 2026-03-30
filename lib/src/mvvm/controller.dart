import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:zren/mvvm.dart';

abstract class ZrenController<S extends BaseState, E extends BaseEffect>
    extends ChangeNotifier {
  S _state;
  S _prevState;
  final StreamController<E> _effectController = StreamController<E>.broadcast();

  Stream<E> get effectStream => _effectController.stream;
  S get state => _state;
  S get prevState => _prevState;

  ZrenController(this._state) : _prevState = _state{
    try {
      Zren.observer.onCreate(this);
    } catch (e,s) {
      Zren.observer.onError(this, e, s);
    }
  }

  void emit(S newState) {
    if (_state == newState) return;
    final change = ZrenChange(currentState: _state, nextState: newState);
    _prevState = _state;
    _state = newState;
    try {
      Zren.observer.onChange(this, change);
    } catch (e, s) {
      Zren.observer.onError(this, e, s);
    }
    notifyListeners();
  }

  void emitEffect(E effect) {
     try {
      Zren.observer.onEffect(this, effect);
    } catch (e, s) {
      Zren.observer.onError(this, e, s);
    }
    _effectController.add(effect);
  }

  @override
  void dispose() {
    try {
      Zren.observer.onDispose(this);
    } catch (e, s) {
      Zren.observer.onError(this, e, s);
    }
    _effectController.close();
    super.dispose();
  }
}
