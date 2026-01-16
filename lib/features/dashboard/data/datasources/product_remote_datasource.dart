import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  final List<ProductModel> _products = [
    const ProductModel(
      id: '1',
      name: 'Product 1',
      description: 'This is a description for product 1.',
      price: 29.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    const ProductModel(
      id: '2',
      name: 'Product 2',
      description: 'This is a description for product 2.',
      price: 49.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    const ProductModel(
      id: '3',
      name: 'Product 3',
      description: 'This is a description for product 3.',
      price: 19.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    // TODO: Implement actual API call with Dio
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    // Simulate a server error if the list is empty for some reason
    if (_products.isEmpty) {
      throw ServerException(message: 'No products found', statusCode: 500);
    }
    return _products;
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    // TODO: Implement actual API call with Dio
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final newProduct = product.copyWith(id: (_products.length + 1).toString());
    _products.add(newProduct);
    return newProduct;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    // TODO: Implement actual API call with Dio
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      return product;
    } else {
      throw NotFoundException(message: 'Product with ID ${product.id} not found');
    }
  }
}
