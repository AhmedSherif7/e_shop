import 'package:dartz/dartz.dart';

import '../../domain/repositories/payment_repository.dart';
import '../../domain/use_cases/base_use_case.dart';
import '../data_sources/payment_data_source.dart';
import '../error/failure.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource paymentDataSource;

  PaymentRepositoryImpl({required this.paymentDataSource});

  @override
  Future<Either<Failure, NoOutput>> makePayment({
    required int amount,
    required String email,
    required String phone,
    required String name,
    required String number,
    required int expirationMonth,
    required int expirationYear,
    required String cvc,
  }) async {
    try {
      await paymentDataSource.makePayment(
        amount: amount,
        email: email,
        name: name,
        phone: phone,
        number: number,
        expirationMonth: expirationMonth,
        expirationYear: expirationYear,
        cvc: cvc,
      );
      return Right(NoOutput());
    } on PaymentFailure catch (error) {
      return Left(error);
    } on Failure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(Failure(message: 'Failed to make transaction'));
    }
  }
}
