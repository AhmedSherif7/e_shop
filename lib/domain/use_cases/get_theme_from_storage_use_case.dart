import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/home_repository.dart';
import 'base_use_case.dart';

class GetThemeFromStorageUseCase extends BaseUseCase<NoParams, bool> {
  final HomeRepository repository;

  GetThemeFromStorageUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams input) async {
    return await repository.getThemeFromStorage();
  }
}
