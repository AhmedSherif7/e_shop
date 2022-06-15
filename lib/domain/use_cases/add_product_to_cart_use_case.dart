import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/product.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class AddProductToCartUseCase extends BaseUseCase<AddProductToCartUseCaseInput,
    List<Map<String, dynamic>>> {
  final UserRepository repository;

  AddProductToCartUseCase(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      AddProductToCartUseCaseInput input) async {
    return await repository.addProductToCart(
      input.cartProducts,
      input.product,
    );
  }
}

class AddProductToCartUseCaseInput {
  final List<Map<String, dynamic>> cartProducts;
  final Product product;

  AddProductToCartUseCaseInput(this.cartProducts, this.product);
}
