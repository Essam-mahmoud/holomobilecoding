import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProductDetails implements UseCase<Product, int> {
  final ProductsRepository repository;

  GetProductDetails(this.repository);

  @override
  Future<Either<Failure, Product>> call(int productId) async {
    return await repository.getProductDetails(productId);
  }
}
