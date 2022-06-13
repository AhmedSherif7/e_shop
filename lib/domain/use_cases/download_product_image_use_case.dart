import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/home_repository.dart';
import 'base_use_case.dart';

class DownLoadProductImageUseCase
    extends BaseUseCase<DownLoadProductImageUseCaseInput, NoOutput> {
  final HomeRepository repository;

  DownLoadProductImageUseCase(this.repository);

  @override
  Future<Either<Failure, NoOutput>> call(
      DownLoadProductImageUseCaseInput input) async {
    return await repository.downloadProductImage(
      input.url,
      input.name,
    );
  }
}

class DownLoadProductImageUseCaseInput {
  final String url;
  final String name;

  DownLoadProductImageUseCaseInput({
    required this.url,
    required this.name,
  });
}
