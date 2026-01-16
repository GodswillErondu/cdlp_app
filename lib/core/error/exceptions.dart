class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server Error', this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache Error'});
}

class UnauthorizedException extends ServerException {
  UnauthorizedException({String message = 'Unauthorized'}) : super(message: message, statusCode: 401);
}

class NotFoundException extends ServerException {
  NotFoundException({String message = 'Not Found'}) : super(message: message, statusCode: 404);
}

class BadRequestException extends ServerException {
  BadRequestException({String message = 'Bad Request'}) : super(message: message, statusCode: 400);
}
