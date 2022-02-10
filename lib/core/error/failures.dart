import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]) : super();
}

// General failures
class ServerException extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CacheException extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
