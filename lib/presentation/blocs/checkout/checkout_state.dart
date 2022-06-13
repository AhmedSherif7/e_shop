part of 'checkout_cubit.dart';

enum CheckoutStep {
  delivery,
  payment,
  summary,
}

enum VoucherStatus {
  loading,
  addedBefore,
  invalid,
  valid,
}

enum PageStatus {
  viewing,
  loading,
}

enum CheckoutPaymentMethod {
  payByCard,
  cashOnDelivery,
}

enum PaymentStatus {
  loading,
  success,
  error,
}

enum OrderSubmitStatus {
  success,
  error,
}

@immutable
class CheckoutState extends Equatable {
  final CheckoutStep checkoutStep;
  final CheckoutPaymentMethod paymentMethod;
  final PageStatus pageStatus;
  final double total;
  final VoucherStatus? voucherStatus;
  final PaymentStatus? paymentStatus;
  final bool? cardValidStatus;
  final String? voucherCode;
  final double? voucher;
  final String? errorMessage;
  final String? number;
  final int? month;
  final int? year;
  final String? cvc;
  final OrderSubmitStatus? orderSubmitStatus;

  const CheckoutState({
    this.checkoutStep = CheckoutStep.delivery,
    this.paymentMethod = CheckoutPaymentMethod.payByCard,
    this.pageStatus = PageStatus.viewing,
    this.total = 0,
    this.voucher,
    this.voucherCode,
    this.voucherStatus,
    this.paymentStatus,
    this.cardValidStatus,
    this.errorMessage,
    this.number,
    this.month,
    this.year,
    this.cvc,
    this.orderSubmitStatus,
  });

  @override
  List<Object?> get props => [
        checkoutStep,
        paymentMethod,
        voucher,
        voucherCode,
        total,
        voucherStatus,
        pageStatus,
        paymentStatus,
        cardValidStatus,
        number,
        month,
        year,
        cvc,
        orderSubmitStatus,
      ];

  CheckoutState copyWith({
    CheckoutStep? checkoutStep,
    CheckoutPaymentMethod? paymentMethod,
    VoucherStatus? voucherStatus,
    PageStatus? pageStatus,
    PaymentStatus? paymentStatus,
    bool? cardValidStatus,
    double? voucher,
    double? total,
    String? voucherCode,
    String? errorMessage,
    String? number,
    int? month,
    int? year,
    String? cvc,
    OrderSubmitStatus? orderSubmitStatus,
  }) {
    return CheckoutState(
      checkoutStep: checkoutStep ?? this.checkoutStep,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      total: total ?? this.total,
      voucher: voucher ?? this.voucher,
      voucherStatus: voucherStatus,
      voucherCode: voucherCode ?? this.voucherCode,
      pageStatus: pageStatus ?? this.pageStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cardValidStatus: cardValidStatus ?? this.cardValidStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      number: number ?? this.number,
      month: month ?? this.month,
      year: year ?? this.year,
      cvc: cvc ?? this.cvc,
      orderSubmitStatus: orderSubmitStatus ?? this.orderSubmitStatus,
    );
  }
}
