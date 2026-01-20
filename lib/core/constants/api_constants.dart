import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.get('BASE_URL', fallback: 'https://dummyjson.com');
  static const String login = '/auth/login';
  static const String products = '/products';
  static const String addProduct = '/products/add';
}
