import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Implement actual API call with Dio
    // For now, returning a mocked user
    print('Calling mock login API for email: $email');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (email == 'test@test.com' && password == 'password') {
      return const UserModel(
        id: '1',
        email: 'test@test.com',
        name: 'Test User',
        token: 'mock_token',
      );
    } else if (email == 'unauthorized@test.com') {
      throw UnauthorizedException();
    } else if (email == 'notfound@test.com') {
      throw NotFoundException();
    } else if (email == 'badrequest@test.com') {
      throw BadRequestException();
    } else {
      throw ServerException(message: 'Invalid credentials or other server error');
    }
  }
}
