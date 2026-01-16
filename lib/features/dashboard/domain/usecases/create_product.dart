import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProduct implements UseCase<Product, Product> {
  final ProductRepository repository;

  CreateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(Product product) async {
    return await repository.createProduct(product);
  }
}
