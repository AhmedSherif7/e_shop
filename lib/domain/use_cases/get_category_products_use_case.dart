import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/product.dart';
import '../repositories/home_repository.dart';
import 'base_use_case.dart';

class GetCategoryProductsUseCase extends BaseUseCase<String, List<Product>> {
  final HomeRepository repository;

  GetCategoryProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String input) async {
    return await repository.getCategoryProducts(input);
  }
}
