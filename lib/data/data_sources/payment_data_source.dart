import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../app/constants.dart';
import '../error/failure.dart';

abstract class PaymentDataSource {
  Future<void> makePayment({
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

class PaymentDataSourceImpl implements PaymentDataSource {
  final Dio dio;

  PaymentDataSourceImpl(this.dio);

  @override
  Future<void> makePayment({
    required int amount,
    required String email,
    required String phone,
    required String name,
    required String number,
    required int expirationMonth,
    required int expirationYear,
    required String cvc,
  }) async {
    final cardDetails = CardDetails(
      number: number,
      expirationMonth: expirationMonth,
      expirationYear: expirationYear,
      cvc: cvc,
    );

    try {
      await Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);
      final billingDetails = BillingDetails(
        email: email,
        phone: '+20$phone',
        name: name,
      );

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );

      final paymentIntentResult = await _callNoWebhookPayEndpointMethodId(
        amount: amount * 100,
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'egp',
      );

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == null) {
        await Stripe.instance.confirmPayment(
          paymentIntentResult['clientSecret'],
          PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
              billingDetails: billingDetails,
            ),
          ),
        );
      }
    } on StripeException catch (error) {
      throw Failure(
        message: error.error.message ??
            'Unknown error occurred while making payment',
      );
    } on StripeError catch (error) {
      throw Failure(
        message: error.message,
      );
    }
  }

  Future<Map<String, dynamic>> _callNoWebhookPayEndpointMethodId({
    required int amount,
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
  }) async {
    final queryParameters = <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'use_stripe_sdk': useStripeSdk,
      'payment_method': paymentMethodId,
    };

    final response = await dio.fetch<Map<String, dynamic>>(
      _setStreamType<void>(
        Options(
          contentType: Constants.applicationUrlEncoded,
          method: 'POST',
          headers: {
            'Authorization': 'Bearer ${Constants.paymentSecretKey}',
          },
        ).compose(
          dio.options,
          Constants.paymentIntentEndPoint,
          queryParameters: queryParameters,
        ),
      ).copyWith(
        baseUrl: dio.options.baseUrl,
      ),
    );

    if (response.statusCode == null) {
      throw UnknownFailure();
    }

    if (response.data == null) {
      throw PaymentFailure(message: 'Failed to get data');
    }

    if (response.statusCode! > 200 || response.data!['error'] != null) {
      throw PaymentFailure.fromCode(
        code: response.statusCode!,
        message: response.data!['error']['message'] ??
            'Unknown error occurred, please try again later',
        type: response.data!['error']['type'] ?? '',
      );
    }

    return response.data!;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
