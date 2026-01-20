import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/error/exceptions.dart';

import '../../../../core/constants/api_constants.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      String username = email;

      // If input looks like an email, try to resolve it to a username
      if (email.contains('@')) {
        try {
          final searchResponse = await dio.get(
            '${ApiConstants.baseUrl}/users/search',
            queryParameters: {'q': email},
          );

          if (searchResponse.statusCode == 200) {
            final List users = searchResponse.data['users'] ?? [];
            if (users.isNotEmpty) {
              // Try to find an exact match for the email
              final exactMatch = users.firstWhere(
                (u) =>
                    u['email'].toString().toLowerCase() == email.toLowerCase(),
                orElse: () => users[0],
              );
              username = exactMatch['username'];
            }
          }
        } catch (e) {
          // If search fails, we'll just fall back to using the original input
          // This is a safety measure to not block login if search is flaky
        }
      }

      final response = await dio.post(
        ApiConstants.baseUrl + ApiConstants.login,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else if (response.statusCode == 400) {
        throw BadRequestException();
      } else {
        throw ServerException(
          message: 'Server Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException();
      } else if (e.response?.statusCode == 400) {
        throw BadRequestException();
      }
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
