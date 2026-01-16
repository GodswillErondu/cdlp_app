import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProduct implements UseCase<Product, Product> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(Product product) async {
    return await repository.updateProduct(product);
  }
}
