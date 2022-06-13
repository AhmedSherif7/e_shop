import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/order.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class GetUserOrdersUseCase extends BaseUseCase<NoParams, List<OrderData>> {
  final UserRepository repository;

  GetUserOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderData>>> call(NoParams input) async {
    return await repository.getUserOrders();
  }
}
