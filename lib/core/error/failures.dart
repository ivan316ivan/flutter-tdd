import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  Failure([List properties = const <dynamic>[]]) : super();
}

// General failures
class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
