import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:zren/src/mvvm/base_effect.dart';
import 'package:zren/src/mvvm/base_state.dart';

abstract class ZrenController<S extends BaseState, E extends BaseEffect>
    extends ChangeNotifier {
  S _state;
  S _prevState;
  final StreamController<E> _effectController = StreamController<E>.broadcast();

  Stream<E> get effectStream => _effectController.stream;
  S get state => _state;
  S get prevState => _prevState;

  ZrenController(this._state) : _prevState = _state;

  void emit(S newState) {
    if (_state == newState) return;
    _prevState = _state;
    _state = newState;
    notifyListeners();
  }

  void emitEffect(E effect) {
    _effectController.add(effect);
  }

  @override
  void dispose() {
    _effectController.close();
    super.dispose();
  }
}
