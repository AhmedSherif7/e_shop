import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/main_repository.dart';
import 'base_use_case.dart';

class WatchOnBoardingUseCase extends BaseUseCase<NoParams, NoOutput> {
  final MainRepository repository;

  WatchOnBoardingUseCase(this.repository);

  @override
  Future<Either<Failure, NoOutput>> call(NoParams input) async {
    return await repository.watchOnBoardScreen();
  }
}
