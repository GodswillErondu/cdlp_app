import 'package:dio/dio.dart';
import 'lib/features/dashboard/data/datasources/product_remote_datasource.dart';
import 'lib/features/dashboard/data/models/product_model.dart';

void main() async {
  final dio = Dio();
  final dataSource = ProductRemoteDataSourceImpl(dio: dio);

  print('Testing updating product with ID 1...');
  final updatedProduct = ProductModel(
    id: '1',
    name: 'Updated Name',
    description: 'Updated description.',
    price: 123.45,
    imageUrl: 'https://i.dummyjson.com/data/products/1/thumbnail.jpg',
  );

  try {
    final result = await dataSource.updateProduct(updatedProduct);
    print('Update successful!');
    print('Returned ID: ${result.id}');
    print('Returned Name: ${result.name}');
    print('Returned Price: ${result.price}');
  } catch (e) {
    if (e is DioException) {
      print('Update failed: ${e.response?.statusCode} - ${e.response?.data}');
    } else {
      print('Update failed: $e');
    }
  }

  print('\nTesting updating a non-existent product (e.g., 999)...');
  final ghostProduct = updatedProduct.copyWith(id: '999');
  try {
    await dataSource.updateProduct(ghostProduct);
    print('Non-existent update unexpectedly succeeded!');
  } catch (e) {
    print('Non-existent update failed as expected: $e');
  }
}
