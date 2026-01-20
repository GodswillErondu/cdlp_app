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
  UnauthorizedException({super.message = 'Unauthorized'})
    : super(statusCode: 401);
}

class NotFoundException extends ServerException {
  NotFoundException({super.message = 'Not Found'}) : super(statusCode: 404);
}

class BadRequestException extends ServerException {
  BadRequestException({super.message = 'Bad Request'}) : super(statusCode: 400);
}
