import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/product.dart';
import '../repositories/home_repository.dart';
import 'base_use_case.dart';

class GetPopularProductsUseCase extends BaseUseCase<NoParams, List<Product>> {
  final HomeRepository _repository;

  GetPopularProductsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams input) async {
    return await _repository.getPopularProducts();
  }
}
