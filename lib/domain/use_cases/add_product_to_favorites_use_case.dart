import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/product.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class AddProductToFavoritesUseCase
    extends BaseUseCase<AddProductToFavoritesUseCaseInput, NoOutput> {
  final UserRepository repository;

  AddProductToFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, NoOutput>> call(
      AddProductToFavoritesUseCaseInput input) async {
    return await repository.addProductToFavorites(
      input.favorites,
      input.product,
    );
  }
}

class AddProductToFavoritesUseCaseInput {
  final List<Product> favorites;
  final Product product;

  AddProductToFavoritesUseCaseInput(this.favorites, this.product);
}
