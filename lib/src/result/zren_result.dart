import 'package:equatable/equatable.dart';

sealed class ZrenResult<T> extends Equatable {
  const factory ZrenResult.success(T data) = ZrenSuccess<T>;
  const factory ZrenResult.failure(Object error, {StackTrace? stackTrace}) =
      ZrenFailure<T>;

  const ZrenResult();

  bool get isSuccess => this is ZrenSuccess;
  bool get isFailure => this is ZrenFailure;

  T? get dataOrNull => switch (this) {
    ZrenSuccess<T>(:final data) => data,
    _ => null,
  };

  Object? get errorOrNull => switch (this) {
    ZrenFailure<T>(:final error) => error,
    _ => null,
  };

  ZrenResult<R> map<R>(R Function(T data) transform) => switch (this) {
    ZrenSuccess<T>(:final data) => ZrenResult.success(transform(data)),
    ZrenFailure<T>(:final error, :final stackTrace) => ZrenResult.failure(
      error,
      stackTrace: stackTrace,
    ),
  };

  R when<R>(
    R Function(T) success,
    R Function(Object? error, StackTrace? stackTrace) failure,
  ) => switch (this) {
    ZrenSuccess<T>(:final data) => success(data),
    ZrenFailure<T>(:final error, :final stackTrace) => failure(
      error,
      stackTrace,
    ),
  };

  @override
  List<Object?> get props;
}

final class ZrenSuccess<T> extends ZrenResult<T> {
  const ZrenSuccess(this.data);
  final T data;

  @override
  List<Object?> get props => [data];
}

final class ZrenFailure<T> extends ZrenResult<T> {
  final Object error;
  final StackTrace? stackTrace;
  const ZrenFailure(this.error, {this.stackTrace});

  @override
  List<Object?> get props => [error, stackTrace];
}
