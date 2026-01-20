import 'package:dio/dio.dart';
import 'lib/features/dashboard/data/datasources/product_remote_datasource.dart';
import 'lib/features/dashboard/data/models/product_model.dart';

void main() async {
  final dio = Dio();
  final dataSource = ProductRemoteDataSourceImpl(dio: dio);

  print('Testing adding a new product...');
  final newProduct = ProductModel(
    name: 'New Test Product',
    description: 'A product created for testing purposes.',
    price: 99.99,
    imageUrl: 'https://i.dummyjson.com/data/products/1/thumbnail.jpg',
  );

  try {
    final result = await dataSource.createProduct(newProduct);
    print('Add successful!');
    print('Returned ID: ${result.id}');
    print('Returned Name: ${result.name}');
    print('Returned Price: ${result.price}');

    if (result.id != null && result.id!.isNotEmpty) {
      print('SUCCESS: Product created with ID ${result.id}');
    } else {
      print('FAILURE: Product created but ID is missing or empty');
    }
  } catch (e) {
    if (e is DioException) {
      print('Add failed: ${e.response?.statusCode} - ${e.response?.data}');
    } else {
      print('Add failed: $e');
    }
  }
}
