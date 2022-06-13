import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/error/failure.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class GetUserLocationUseCase extends BaseUseCase<NoParams, Position> {
  final UserRepository repository;

  GetUserLocationUseCase(this.repository);

  @override
  Future<Either<Failure, Position>> call(NoParams input) async {
    return await repository.getUserLocation();
  }
}
