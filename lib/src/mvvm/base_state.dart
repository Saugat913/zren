import 'package:equatable/equatable.dart';

abstract base class BaseState extends Equatable {
  const BaseState();
  @override
  List<Object?> get props;
}
