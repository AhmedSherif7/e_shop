import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/error/failure.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class GetImageFromGalleryUseCase extends BaseUseCase<NoParams, XFile> {
  final UserRepository repository;

  GetImageFromGalleryUseCase(this.repository);

  @override
  Future<Either<Failure, XFile>> call(NoParams input) async {
    return await repository.getImageFromGallery();
  }
}
