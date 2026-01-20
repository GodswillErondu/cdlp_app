import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> productsToCache);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final FlutterSecureStorage secureStorage;

  ProductLocalDataSourceImpl({required this.secureStorage});

  static const String _cachedProductsKey = 'CACHED_PRODUCTS';

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = await secureStorage.read(key: _cachedProductsKey);
    if (jsonString != null) {
      return (json.decode(jsonString) as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) async {
    await secureStorage.write(
      key: _cachedProductsKey,
      value: json.encode(
        productsToCache.map((product) => product.toJson()).toList(),
      ),
    );
  }
}
