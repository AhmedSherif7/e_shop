import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';

import '../../data/error/failure.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class GetUserAddressUseCase
    extends BaseUseCase<GetUserAddressUseCaseInput, Placemark> {
  final UserRepository repository;

  GetUserAddressUseCase(this.repository);

  @override
  Future<Either<Failure, Placemark>> call(
      GetUserAddressUseCaseInput input) async {
    return await repository.getUserAddress(
      input.longitude,
      input.latitude,
    );
  }
}

class GetUserAddressUseCaseInput {
  final double longitude;
  final double latitude;

  GetUserAddressUseCaseInput(this.longitude, this.latitude);
}
