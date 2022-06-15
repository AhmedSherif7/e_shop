import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/product.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class RemoveProductFromFavoritesUseCase
    extends BaseUseCase<RemoveProductFromFavoritesUseCaseInput, List<Product>> {
  final UserRepository repository;

  RemoveProductFromFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
      RemoveProductFromFavoritesUseCaseInput input) async {
    return await repository.removeProductFromFavorites(
      input.favorites,
      input.productId,
    );
  }
}

class RemoveProductFromFavoritesUseCaseInput {
  final List<Product> favorites;
  final String productId;

  RemoveProductFromFavoritesUseCaseInput(this.favorites, this.productId);
}
