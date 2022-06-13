import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../repositories/user_repository.dart';
import 'base_use_case.dart';

class MakeOrderUseCase extends BaseUseCase<MakeOrderUseCaseInput, NoOutput> {
  final UserRepository userRepository;

  MakeOrderUseCase(this.userRepository);

  @override
  Future<Either<Failure, NoOutput>> call(MakeOrderUseCaseInput input) async {
    return await userRepository.makeOrder(
      governorate: input.governorate,
      city: input.city,
      street: input.street,
      postalCode: input.postalCode,
      products: input.products,
      totalPrice: input.totalPrice,
      paymentMethod: input.paymentMethod,
      voucher: input.voucher,
      shippingFees: input.shippingFees,
    );
  }
}

class MakeOrderUseCaseInput {
  final String governorate;
  final String city;
  final String street;
  final String postalCode;
  final List<Map<String, dynamic>> products;
  final double totalPrice;
  final String paymentMethod;
  final double voucher;
  final double shippingFees;

  MakeOrderUseCaseInput({
    required this.governorate,
    required this.city,
    required this.street,
    required this.postalCode,
    required this.products,
    required this.totalPrice,
    required this.paymentMethod,
    required this.voucher,
    required this.shippingFees,
  });
}
