import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../domain/use_cases/add_voucher_use_case.dart';
import '../../../domain/use_cases/make_order_use_case.dart';
import '../../../domain/use_cases/make_payment_use_case.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final controller = ScrollController();

  CheckoutCubit(
    this.addVoucherUseCase,
    this.makePaymentUseCase,
    this.makeOrderUseCase,
  ) : super(const CheckoutState());

  final AddVoucherUseCase addVoucherUseCase;
  final MakePaymentUseCase makePaymentUseCase;
  final MakeOrderUseCase makeOrderUseCase;

  void getTotal(double productsPrice) {
    emit(
      state.copyWith(
        total: productsPrice + 57,
      ),
    );
  }

  void nextPage() {
    emit(
      state.copyWith(
        checkoutStep: state.checkoutStep == CheckoutStep.delivery
            ? CheckoutStep.payment
            : CheckoutStep.summary,
      ),
    );
    scrollToTop();
  }

  void prevPage() {
    emit(
      state.copyWith(
        checkoutStep: state.checkoutStep == CheckoutStep.summary
            ? CheckoutStep.payment
            : CheckoutStep.delivery,
      ),
    );
    scrollToTop();
  }

  void changePaymentMethod(CheckoutPaymentMethod? value) {
    emit(
      state.copyWith(
        paymentMethod: value!,
      ),
    );
  }

  void goToPayment() {
    emit(
      state.copyWith(
        checkoutStep: CheckoutStep.payment,
      ),
    );
    scrollToTop();
  }

  void addVoucher(String code) async {
    emit(
      state.copyWith(
        voucherStatus: VoucherStatus.loading,
      ),
    );

    final result = await addVoucherUseCase(code);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            voucherStatus: VoucherStatus.invalid,
            errorMessage: error.message,
          ),
        );
      },
      (value) {
        if (value['code'] == state.voucherCode) {
          emit(
            state.copyWith(
              voucherStatus: VoucherStatus.addedBefore,
              errorMessage: 'coupon code already applied',
            ),
          );
        } else {
          final totalWithoutFees = state.total - 57;
          emit(
            state.copyWith(
              voucher: value['value'],
              voucherCode: value['code'],
              voucherStatus: VoucherStatus.valid,
              total:
                  (totalWithoutFees - (totalWithoutFees * value['value'])) + 57,
            ),
          );
        }
      },
    );
  }

  void cardChanged(CardFieldInputDetails? card) {
    if (card == null) {
      emit(
        state.copyWith(
          cardValidStatus: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          number: card.number,
          month: card.expiryMonth,
          year: card.expiryYear,
          cvc: card.cvc,
          cardValidStatus: card.validNumber == CardValidationState.Valid &&
              card.validExpiryDate == CardValidationState.Valid &&
              card.validCVC == CardValidationState.Valid,
        ),
      );
    }
  }

  void makePayment({
    required double amount,
    required String email,
    required String phone,
    required String name,
  }) async {
    emit(
      state.copyWith(
        paymentStatus: PaymentStatus.loading,
      ),
    );

    final result = await makePaymentUseCase(
      MakePaymentUseCaseInput(
        amount: amount.toInt(),
        number: state.number!,
        expirationMonth: state.month!,
        expirationYear: state.year!,
        cvc: state.cvc!,
        email: email,
        name: name,
        phone: phone,
      ),
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            paymentStatus: PaymentStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            paymentStatus: PaymentStatus.success,
          ),
        );
      },
    );
  }

  void makeOrder({
    required String governorate,
    required String city,
    required String street,
    required String postalCode,
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required double shippingFees,
  }) async {
    emit(
      state.copyWith(
        pageStatus: PageStatus.loading,
      ),
    );

    final result = await makeOrderUseCase(
      MakeOrderUseCaseInput(
        governorate: governorate,
        city: city,
        street: street,
        postalCode: postalCode,
        products: products,
        totalPrice: totalPrice,
        paymentMethod: state.paymentMethod == CheckoutPaymentMethod.payByCard
            ? 'Pay by Card'
            : 'Cash on Delivery',
        voucher: state.voucher ?? 0,
        shippingFees: shippingFees,
      ),
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.viewing,
            orderSubmitStatus: OrderSubmitStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.viewing,
            orderSubmitStatus: OrderSubmitStatus.success,
          ),
        );
      },
    );
  }

  void scrollToTop() {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }
}
