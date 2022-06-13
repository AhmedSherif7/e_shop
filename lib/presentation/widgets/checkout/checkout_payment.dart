import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/checkout/checkout_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import 'checkout_container.dart';
import 'checkout_voucher.dart';

class CheckoutPayment extends StatefulWidget {
  const CheckoutPayment({Key? key}) : super(key: key);

  @override
  State<CheckoutPayment> createState() => _CheckoutPaymentState();
}

class _CheckoutPaymentState extends State<CheckoutPayment> {
  final voucherController = TextEditingController();

  @override
  void dispose() {
    voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return CheckoutContainer(
                title: [
                  Text(
                    'PAYMENT METHOD',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: state.isDarkMode
                          ? ColorManager.white
                          : ColorManager.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      fontFamily: FontFamilyManager.montserrat,
                    ),
                  ),
                ],
                child: BlocSelector<CheckoutCubit, CheckoutState,
                    CheckoutPaymentMethod>(
                  selector: (state) {
                    return state.paymentMethod;
                  },
                  builder: (context, paymentMethod) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: state.isDarkMode
                            ? Colors.white
                            : ColorManager.black,
                      ),
                      child: Column(
                        children: [
                          RadioListTile<CheckoutPaymentMethod>(
                            value: CheckoutPaymentMethod.payByCard,
                            title: Text(
                              'Pay by Card',
                              style: TextStyle(
                                color: state.isDarkMode
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                            ),
                            groupValue: paymentMethod,
                            activeColor: ColorManager.primary,
                            autofocus: true,
                            onChanged: context
                                .read<CheckoutCubit>()
                                .changePaymentMethod,
                            subtitle:
                                paymentMethod == CheckoutPaymentMethod.payByCard
                                    ? Text(
                                        'For Contactless Delivery we recommend go cashless and stay safe.',
                                        style: TextStyle(
                                          color: state.isDarkMode
                                              ? ColorManager.white
                                              : ColorManager.black,
                                        ),
                                      )
                                    : null,
                          ),
                          RadioListTile<CheckoutPaymentMethod>(
                            value: CheckoutPaymentMethod.cashOnDelivery,
                            title: Text(
                              'Cash on Delivery',
                              style: TextStyle(
                                color: state.isDarkMode
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                            ),
                            groupValue: paymentMethod,
                            activeColor: ColorManager.primary,
                            onChanged: context
                                .read<CheckoutCubit>()
                                .changePaymentMethod,
                            subtitle: paymentMethod ==
                                    CheckoutPaymentMethod.cashOnDelivery
                                ? Text(
                                    'When you choose Cash on delivery, you can pay for your order in cash when you receive your shipment at home.',
                                    style: TextStyle(
                                      color: state.isDarkMode
                                          ? ColorManager.white
                                          : ColorManager.black,
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          CheckoutVoucher(
            voucherController: voucherController,
          ),
        ],
      ),
    );
  }
}
