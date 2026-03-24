import 'package:equatable/equatable.dart';

sealed class AsyncState<T> extends Equatable {
  const AsyncState();

  const factory AsyncState.initial() = AsyncInitialState<T>;
  const factory AsyncState.loading() = AsyncLoadingState<T>;
  const factory AsyncState.success(T data) = AsyncSuccessState<T>;
  const factory AsyncState.failure(Object? error, {StackTrace? stackTrace}) =
      AsyncFailureState<T>;

  bool get isInitial => this is AsyncInitialState;
  bool get isLoading => this is AsyncLoadingState;
  bool get isSuccess => this is AsyncSuccessState;
  bool get isFailure => this is AsyncFailureState;

  R when<R>({
    required R Function(T data) success,
    required R Function() initial,
    required R Function() loading,
    required R Function(Object? error, {StackTrace? stackTrace}) failure,
  }) => switch (this) {
    AsyncInitialState<T>() => initial.call(),
    AsyncLoadingState<T>() => loading.call(),
    AsyncSuccessState<T>(:final data) => success.call(data),
    AsyncFailureState<T>(:final error, :final stackTrace) => failure.call(
      error,
      stackTrace: stackTrace,
    ),
  };

  R maybeWhen<R>({
    R Function(T data)? success,
    R Function()? initial,
    R Function()? loading,
    R Function(Object? error, {StackTrace? stackTrace})? failure,
    required R Function() orElse,
  }) => switch (this) {
    AsyncInitialState<T>() => initial?.call() ?? orElse(),
    AsyncLoadingState<T>() => loading?.call() ?? orElse(),
    AsyncSuccessState<T>(:final data) => success?.call(data) ?? orElse(),
    AsyncFailureState<T>(:final error, :final stackTrace) =>
      failure?.call(error, stackTrace: stackTrace) ?? orElse(),
  };

  AsyncState<R> map<R>(R Function(T data) transform) => switch (this) {
    AsyncInitialState<T>() => AsyncInitialState(),
    AsyncLoadingState<T>() => AsyncLoadingState(),
    AsyncSuccessState<T>(:final data) => AsyncSuccessState(transform(data)),
    AsyncFailureState<T>(:final error, :final stackTrace) => AsyncFailureState(
      error,
      stackTrace: stackTrace,
    ),
  };

  @override
  List<Object?> get props;
}

final class AsyncInitialState<T> extends AsyncState<T> {
  const AsyncInitialState();

  @override
  List<Object?> get props => [];
}

final class AsyncLoadingState<T> extends AsyncState<T> {
  const AsyncLoadingState();

  @override
  List<Object?> get props => [];
}

final class AsyncSuccessState<T> extends AsyncState<T> {
  const AsyncSuccessState(this.data);
  final T data;
  @override
  List<Object?> get props => [data];
}

final class AsyncFailureState<T> extends AsyncState<T> {
  const AsyncFailureState(this.error, {this.stackTrace});
  final Object? error;
  final StackTrace? stackTrace;
  @override
  List<Object?> get props => [error, stackTrace];
}
