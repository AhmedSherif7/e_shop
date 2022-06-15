import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class RemoveProductFromCartUseCase extends BaseUseCase<
    RemoveProductFromCartUseCaseInput, List<Map<String, dynamic>>> {
  final UserRepository _repository;

  RemoveProductFromCartUseCase(this._repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      RemoveProductFromCartUseCaseInput input) async {
    return await _repository.removeProductFromCart(
      input.cartProducts,
      input.productId,
    );
  }
}

class RemoveProductFromCartUseCaseInput {
  final List<Map<String, dynamic>> cartProducts;
  final String productId;

  RemoveProductFromCartUseCaseInput(this.cartProducts, this.productId);
}
