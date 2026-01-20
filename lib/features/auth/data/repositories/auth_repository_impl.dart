import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/secure_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.secureStorageService,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.login(email, password);
        if (remoteUser.token != null) {
          await secureStorageService.saveToken(remoteUser.token!);
        }
        return Right(remoteUser);
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on BadRequestException {
        return Left(BadRequestFailure());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
