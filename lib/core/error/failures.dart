import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure([this.message = 'An unexpected error occurred', List properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [message, ...properties];
}

// General failures
class ServerFailure extends Failure {
  ServerFailure({String message = 'Server Failure'}) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure({String message = 'Cache Failure'}) : super(message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({String message = 'Unauthorized'}) : super(message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure({String message = 'Not Found'}) : super(message);
}

class BadRequestFailure extends Failure {
  BadRequestFailure({String message = 'Bad Request'}) : super(message);
}
