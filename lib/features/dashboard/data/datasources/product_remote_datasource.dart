import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../../../../core/error/exceptions.dart';

import '../../../../core/constants/api_constants.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get(
        ApiConstants.baseUrl + ApiConstants.products,
      );

      if (response.statusCode == 200) {
        return (response.data['products'] as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          message: 'Server Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await dio.post(
        ApiConstants.baseUrl + ApiConstants.addProduct,
        data: product.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Server Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await dio.put(
        '${ApiConstants.baseUrl}${ApiConstants.products}/${product.id}',
        data: product.toJson(),
      );

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw NotFoundException(
          message: 'Product with ID ${product.id} not found',
        );
      } else {
        throw ServerException(
          message: 'Server Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(
          message: 'Product with ID ${product.id} not found',
        );
      }
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
