import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/product.dart';
import '../repositories/main_repository.dart';
import 'base_use_case.dart';

class ProductSearchUseCase extends BaseUseCase<String, List<Product>> {
  final MainRepository repository;

  ProductSearchUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String input) async {
    return await repository.productSearch(input);
  }
}
