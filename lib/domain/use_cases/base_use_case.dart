import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';

abstract class BaseUseCase<Input, Output> {
  Future<Either<Failure, Output>> call(Input input);
}

class NoParams {}

class NoOutput {}
