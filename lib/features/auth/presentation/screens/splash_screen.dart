import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdlp_app/core/services/secure_storage_service.dart';
import 'package:cdlp_app/features/auth/presentation/screens/login_screen.dart';
import 'package:cdlp_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// This is a placeholder for a more robust provider setup
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});


class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String?>(
      future: ref.read(secureStorageServiceProvider).getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // If token exists, navigate to Dashboard
          return const DashboardScreen();
        } else {
          // If no token, navigate to Login
          return const LoginScreen();
        }
      },
    );
  }
}
