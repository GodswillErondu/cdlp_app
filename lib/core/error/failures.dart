import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final List<Object?> properties;

  const Failure([
    this.message = 'An unexpected error occurred',
    this.properties = const <Object?>[],
  ]);

  @override
  List<Object?> get props => [message, properties];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server Failure'}) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache Failure'}) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String message = 'Unauthorized'}) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'Not Found'}) : super(message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({String message = 'Bad Request'}) : super(message);
}
