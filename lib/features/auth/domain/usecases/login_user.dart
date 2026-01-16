import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class LoginUser implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
