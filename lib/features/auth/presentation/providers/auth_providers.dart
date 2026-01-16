import 'package:cdlp_app/features/auth/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_user.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/failures.dart';

// Common services
final dioProvider = Provider<Dio>((ref) => Dio());
final secureStorageProvider =
    Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());
final dioClientProvider = Provider<DioClient>((ref) => DioClient(
    dio: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider)));
final secureStorageServiceProvider = Provider<SecureStorageService>(
    (ref) => SecureStorageService(ref.watch(secureStorageProvider)));
final connectivityProvider =
    Provider<Connectivity>((ref) => Connectivity());
final networkInfoProvider = Provider<NetworkInfo>(
    (ref) => NetworkInfoImpl(ref.watch(connectivityProvider)));

// Auth specific providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
    (ref) => AuthRemoteDataSourceImpl(dio: ref.watch(dioProvider)));

final authRepositoryProvider = Provider<AuthRepository>((ref) =>
    AuthRepositoryImpl(
      remoteDataSource: ref.watch(authRemoteDataSourceProvider),
      networkInfo: ref.watch(networkInfoProvider),
      secureStorageService: ref.watch(secureStorageServiceProvider),
    ));

final loginUserProvider =
    Provider<LoginUser>((ref) => LoginUser(ref.watch(authRepositoryProvider)));

final userProvider = StateProvider<User?>((ref) => null);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(loginUserProvider), ref);
});


class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUser _loginUser;
  final Ref _ref;

  AuthNotifier(this._loginUser, this._ref) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    final result = await _loginUser(LoginParams(email: email, password: password));
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        _ref.read(userProvider.notifier).state = null;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user, error: null);
        _ref.read(userProvider.notifier).state = user;
      },
    );
  }
}
