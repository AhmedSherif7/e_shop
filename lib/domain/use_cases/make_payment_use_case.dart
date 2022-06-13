import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/payment_repository.dart';
import 'base_use_case.dart';

class MakePaymentUseCase
    extends BaseUseCase<MakePaymentUseCaseInput, NoOutput> {
  final PaymentRepository repository;

  MakePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, NoOutput>> call(MakePaymentUseCaseInput input) async {
    return await repository.makePayment(
      amount: input.amount,
      name: input.name,
      email: input.email,
      phone: input.phone,
      number: input.number,
      expirationMonth: input.expirationMonth,
      expirationYear: input.expirationYear,
      cvc: input.cvc,
    );
  }
}

class MakePaymentUseCaseInput {
  final int amount;
  final String email;
  final String phone;
  final String name;
  final String number;
  final int expirationMonth;
  final int expirationYear;
  final String cvc;

  MakePaymentUseCaseInput({
    required this.amount,
    required this.email,
    required this.phone,
    required this.name,
    required this.number,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cvc,
  });
}
