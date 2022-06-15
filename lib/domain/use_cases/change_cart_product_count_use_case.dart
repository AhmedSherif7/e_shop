import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class ChangeCartProductCountUseCase
    extends BaseUseCase<ChangeCartProductCountUseCaseInput, List<Map<String, dynamic>>> {
  final UserRepository repository;

  ChangeCartProductCountUseCase(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      ChangeCartProductCountUseCaseInput input) async {
    return await repository.changeCartProductCount(
      input.cartProducts,
      input.productId,
      input.isAdd,
    );
  }
}

class ChangeCartProductCountUseCaseInput {
  final List<Map<String, dynamic>> cartProducts;
  final String productId;
  final bool isAdd;

  ChangeCartProductCountUseCaseInput(
    this.cartProducts,
    this.productId,
    this.isAdd,
  );
}
