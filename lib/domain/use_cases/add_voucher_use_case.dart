import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class AddVoucherUseCase extends BaseUseCase<String, Map<String, dynamic>> {
  final UserRepository repository;

  AddVoucherUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String input) async {
    return await repository.addVoucher(input);
  }
}
