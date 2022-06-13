import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/checkout/checkout_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import 'checkout_address.dart';
import 'checkout_container.dart';
import 'checkout_voucher.dart';

class CheckoutSummary extends StatefulWidget {
  const CheckoutSummary({Key? key}) : super(key: key);

  @override
  State<CheckoutSummary> createState() => _CheckoutSummaryState();
}

class _CheckoutSummaryState extends State<CheckoutSummary> {
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
          const CheckoutAddress(),
          const SizedBox(
            height: 15.0,
          ),
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
                  TextButton(
                    onPressed: () {
                      context.read<CheckoutCubit>().goToPayment();
                    },
                    child: const Text('CHANGE'),
                    style: ButtonStyle(
                      alignment: Alignment.bottomCenter,
                      foregroundColor: MaterialStateProperty.all(
                        ColorManager.indigo,
                      ),
                      overlayColor: MaterialStateProperty.all(
                        ColorManager.primary,
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(0),
                      ),
                    ),
                  ),
                ],
                child: BlocSelector<CheckoutCubit, CheckoutState,
                    CheckoutPaymentMethod>(
                  selector: (state) {
                    return state.paymentMethod;
                  },
                  builder: (context, paymentMethod) {
                    return RadioListTile<CheckoutPaymentMethod>(
                      value: paymentMethod,
                      title: Text(
                        paymentMethod == CheckoutPaymentMethod.payByCard
                            ? 'Pay by Card'
                            : 'Cash on Delivery',
                        style: TextStyle(
                          color: state.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                        ),
                      ),
                      groupValue: paymentMethod,
                      activeColor: ColorManager.primary,
                      autofocus: true,
                      subtitle: Text(
                        paymentMethod == CheckoutPaymentMethod.payByCard
                            ? 'For Contactless Delivery we recommend go cashless and stay safe.'
                            : 'When you choose Cash on delivery, you can pay for your order in cash when you receive your shipment at home.',
                        style: TextStyle(
                          color: state.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                        ),
                      ),
                      onChanged: (value) {},
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
