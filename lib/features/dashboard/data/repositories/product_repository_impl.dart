import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts();
        return Right(remoteProducts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on BadRequestException {
        return Left(BadRequestFailure());
      }
    } else {
      // TODO: Implement local data source for caching
      return Left(ServerFailure(message: 'No Internet Connection')); // Or a specific OfflineFailure
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );
        final remoteProduct = await remoteDataSource.createProduct(productModel);
        return Right(remoteProduct);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on BadRequestException {
        return Left(BadRequestFailure());
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );
        final remoteProduct = await remoteDataSource.updateProduct(productModel);
        return Right(remoteProduct);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on BadRequestException {
        return Left(BadRequestFailure());
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
