import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/category.dart';
import '../repositories/main_repository.dart';
import 'base_use_case.dart';

class GetCategoriesUseCase extends BaseUseCase<NoParams, List<Category>> {
  final MainRepository _repository;

  GetCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams input) async {
    return await _repository.getCategories();
  }
}
