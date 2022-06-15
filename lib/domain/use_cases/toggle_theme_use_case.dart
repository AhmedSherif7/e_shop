import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/main_repository.dart';
import 'base_use_case.dart';

class ToggleThemeUseCase extends BaseUseCase<bool, NoOutput> {
  final MainRepository repository;

  ToggleThemeUseCase(this.repository);

  @override
  Future<Either<Failure, NoOutput>> call(bool input) async {
    return await repository.toggleTheme(input);
  }
}
