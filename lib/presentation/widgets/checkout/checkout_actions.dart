import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/checkout/checkout_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../resources/colors_manager.dart';
import '../custom_button.dart';
import 'checkout_bottom_sheet.dart';

class CheckoutActions extends StatelessWidget {
  const CheckoutActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CheckoutCubit, CheckoutState, CheckoutStep>(
      selector: (state) {
        return state.checkoutStep;
      },
      builder: (context, checkoutStep) {
        return Column(
          children: [
            if (checkoutStep == CheckoutStep.delivery)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Text(
                      'You be able to apply a voucher on the next step',
                      style: TextStyle(
                        color: state.isDarkMode
                            ? ColorManager.white
                            : ColorManager.black,
                      ),
                    );
                  },
                ),
              ),
            if (checkoutStep != CheckoutStep.delivery)
              const SizedBox(
                height: 10.0,
              ),
            Row(
              children: [
                if (checkoutStep != CheckoutStep.delivery)
                  Expanded(
                    child: CustomButton(
                      color: ColorManager.indigo,
                      height: 50,
                      title: 'PREVIOUS',
                      onTap: () {
                        context.read<CheckoutCubit>().prevPage();
                      },
                    ),
                  ),
                const SizedBox(
                  width: 10.0,
                ),
                if (checkoutStep == CheckoutStep.delivery ||
                    checkoutStep == CheckoutStep.payment)
                  Expanded(
                    child: CustomButton(
                      color: ColorManager.indigo,
                      height: 50,
                      title: 'NEXT',
                      onTap: () {
                        context.read<CheckoutCubit>().nextPage();
                      },
                    ),
                  ),
                if (checkoutStep == CheckoutStep.summary)
                  Expanded(
                    child: BlocBuilder<CheckoutCubit, CheckoutState>(
                      buildWhen: (previous, current) {
                        return previous.paymentMethod !=
                                current.paymentMethod ||
                            previous.paymentStatus != current.paymentStatus;
                      },
                      builder: (context, state) {
                        return CustomButton(
                          color: ColorManager.indigo,
                          height: 50,
                          title: state.paymentMethod ==
                                  CheckoutPaymentMethod.cashOnDelivery
                              ? 'CONFIRM'
                              : 'Pay & Confirm',
                          onTap: state.paymentMethod ==
                                  CheckoutPaymentMethod.payByCard
                              ? () {
                                  showModalBottomSheet(
                                    isDismissible: state.paymentStatus !=
                                        PaymentStatus.loading,
                                    enableDrag: state.paymentStatus !=
                                        PaymentStatus.loading,
                                    context: context,
                                    builder: (_) {
                                      return BlocProvider<UserBloc>.value(
                                        value: context.read<UserBloc>(),
                                        child:
                                            BlocProvider<CheckoutCubit>.value(
                                          value: context.read<CheckoutCubit>(),
                                          child: CheckoutBottomSheet(
                                            price: context
                                                .read<CheckoutCubit>()
                                                .state
                                                .total,
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    context
                                        .read<CheckoutCubit>()
                                        .cardChanged(null);
                                  });
                                }
                              : () {
                                  final user =
                                      context.read<UserBloc>().state.user;
                                  context.read<CheckoutCubit>().makeOrder(
                                        governorate: user.governorate,
                                        city: user.city,
                                        street: user.street,
                                        postalCode: user.postalCode,
                                        products: user.cartProducts,
                                        totalPrice: context
                                            .read<CheckoutCubit>()
                                            .state
                                            .total,
                                        shippingFees: 57,
                                      );
                                },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
