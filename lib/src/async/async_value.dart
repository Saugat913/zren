import 'package:flutter/widgets.dart';
import 'async_state.dart';

/// A reactive wrapper around [AsyncState] that notifies listeners on state changes.
class AsyncValue<T> extends ValueNotifier<AsyncState<T>> {
  AsyncValue([AsyncState<T>? initial]) : super(initial ?? AsyncState<T>.initial());

  void emit(AsyncState<T> newState) => value = newState;
  void loading() => emit(AsyncState<T>.loading());
  void success(T data) => emit(AsyncState<T>.success(data));
  void failure(Object error, [StackTrace? stackTrace]) => 
      emit(AsyncState<T>.failure(error, stackTrace: stackTrace));

  AsyncState<T> get state => value;
  T? get data => value.dataOrNull;
  Object? get error => value.errorOrNull;
  bool get isLoading => value.isLoading;
  bool get isSuccess => value.isSuccess;
  bool get isFailure => value.isFailure;

  R when<R>({
    required R Function(T data) success,
    required R Function() initial,
    required R Function() loading,
    required R Function(Object? error, {StackTrace? stackTrace}) failure,
  }) => value.when(success: success, initial: initial, loading: loading, failure: failure);
}


