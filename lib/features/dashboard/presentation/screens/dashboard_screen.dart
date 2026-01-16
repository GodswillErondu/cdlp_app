import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdlp_app/core/services/secure_storage_service.dart';
import 'package:cdlp_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/product_list_item.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/domain/entities/user.dart';
import '../providers/dashboard_providers.dart';
import 'product_form_screen.dart';
import '../../domain/entities/product.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:intl/intl.dart';


// This is a placeholder for a more robust provider setup
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(userProvider);
    final ProductListState productListState = ref.watch(productListProvider);
    final String formattedDate = DateFormat.yMMMd().format(DateTime.now());


    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(secureStorageServiceProvider).deleteToken();
              ref.read(userProvider.notifier).state = null;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Summary
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade100,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user?.avatarUrl != null
                      ? NetworkImage(user!.avatarUrl!)
                      : null,
                  child: user?.avatarUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'User Name',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(user?.email ?? 'user.email@example.com'),
                    Text(formattedDate),
                  ],
                ),
              ],
            ),
          ),
          // Asynchronous List
          Expanded(
            child: productListState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productListState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(productListState.error!),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(productListProvider.notifier).getProducts();
                              },
                              child: const Text('Retry'),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: productListState.products?.length ?? 0,
                        itemBuilder: (context, index) {
                          final product = productListState.products![index];
                          return ProductListItem(product: product);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProductFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

