import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../use_cases/base_use_case.dart';

abstract class AuthRepository {
  Future<Either<Failure, NoOutput>> login(
    String email,
    String password,
  );

  Future<Either<Failure, NoOutput>> register(
    String email,
    String password,
  );

  Future<Either<Failure, NoOutput>> logout();
}
