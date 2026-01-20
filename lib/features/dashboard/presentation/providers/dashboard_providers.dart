import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/entities/product.dart';
import '../../../../core/usecases/usecase.dart';

// Product specific providers
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSourceImpl(dio: ref.watch(dioProvider)),
);

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>(
  (ref) => ProductLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
  ),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    remoteDataSource: ref.watch(productRemoteDataSourceProvider),
    localDataSource: ref.watch(productLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getProductsProvider = Provider<GetProducts>(
  (ref) => GetProducts(ref.watch(productRepositoryProvider)),
);
final createProductProvider = Provider<CreateProduct>(
  (ref) => CreateProduct(ref.watch(productRepositoryProvider)),
);
final updateProductProvider = Provider<UpdateProduct>(
  (ref) => UpdateProduct(ref.watch(productRepositoryProvider)),
);

final productListProvider =
    StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
      return ProductListNotifier(
        ref.watch(getProductsProvider),
        ref.watch(createProductProvider),
        ref.watch(updateProductProvider),
      );
    });

class ProductListState {
  final List<Product>? products;
  final bool isLoading;
  final String? error;

  ProductListState({this.products, this.isLoading = false, this.error});

  ProductListState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProductListNotifier extends StateNotifier<ProductListState> {
  final GetProducts _getProducts;
  final CreateProduct _createProduct;
  final UpdateProduct _updateProduct;

  ProductListNotifier(
    this._getProducts,
    this._createProduct,
    this._updateProduct,
  ) : super(ProductListState()) {
    getProducts();
  }

  Future<void> getProducts() async {
    state = state.copyWith(isLoading: true);
    final result = await _getProducts(NoParams());
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (products) {
        state = state.copyWith(
          isLoading: false,
          products: products,
          error: null,
        );
      },
    );
  }

  Future<void> createProduct(Product product) async {
    state = state.copyWith(isLoading: true);
    final result = await _createProduct(product);
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (newProduct) {
        state = state.copyWith(
          isLoading: false,
          products: [...(state.products ?? []), newProduct],
          error: null,
        );
      },
    );
  }

  Future<void> updateProduct(Product product) async {
    state = state.copyWith(isLoading: true);
    final result = await _updateProduct(product);
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (updatedProduct) {
        state = state.copyWith(
          isLoading: false,
          products: state.products!
              .map((p) => p.id == updatedProduct.id ? updatedProduct : p)
              .toList(),
          error: null,
        );
      },
    );
  }
}
