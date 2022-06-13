import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../use_cases/base_use_case.dart';

abstract class PaymentRepository {
  Future<Either<Failure, NoOutput>> makePayment({
    required int amount,
    required String email,
    required String phone,
    required String name,
    required String number,
    required int expirationMonth,
    required int expirationYear,
    required String cvc,
  });
}
