import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../app/di.dart';
import '../../app/functions.dart';
import '../blocs/checkout/checkout_cubit.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/user/user_bloc.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';
import '../widgets/checkout/checkout_actions.dart';
import '../widgets/checkout/checkout_container.dart';
import '../widgets/checkout/checkout_delivery.dart';
import '../widgets/checkout/checkout_payment.dart';
import '../widgets/checkout/checkout_summary.dart';
import '../widgets/checkout/checkout_timeline.dart';
import '../widgets/loading_widget.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listenWhen: (previous, current) =>
          current.userDataStatus == UserDataStatus.success,
      listener: (context, state) {
        if (state.userDataStatus == UserDataStatus.success) {
          Navigator.pop(context);
        }
      },
      child: BlocProvider<CheckoutCubit>(
        create: (context) => sl<CheckoutCubit>()
          ..getTotal(context.read<UserBloc>().state.totalPrice),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Checkout'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Ionicons.chevron_back_outline,
              ),
            ),
          ),
          body: BlocConsumer<CheckoutCubit, CheckoutState>(
            listenWhen: (previous, current) {
              return previous.orderSubmitStatus != current.orderSubmitStatus ||
                  previous.voucher != current.voucher;
            },
            listener: (context, state) {
              if (state.voucherStatus == VoucherStatus.valid) {
                showToast(
                  message: 'Coupon code applied',
                  state: ToastStates.success,
                );
              }

              if (state.orderSubmitStatus == OrderSubmitStatus.error) {
                showToast(
                  message: state.errorMessage!,
                  state: ToastStates.error,
                );
              }
              if (state.orderSubmitStatus == OrderSubmitStatus.success) {
                context.read<UserBloc>().add(UserOrderCreated());
                showToast(
                  message: 'Order submitted',
                  state: ToastStates.success,
                );
              }
            },
            buildWhen: (previous, current) =>
                previous.pageStatus != current.pageStatus,
            builder: (context, state) {
              if (state.pageStatus == PageStatus.loading) {
                return const Center(
                  child: LoadingWidget(),
                );
              }
              return SingleChildScrollView(
                controller: context.read<CheckoutCubit>().controller,
                child: Column(
                  children: [
                    const CheckoutTimeline(),
                    BlocSelector<CheckoutCubit, CheckoutState, CheckoutStep>(
                      selector: (state) {
                        return state.checkoutStep;
                      },
                      builder: (context, checkoutStep) {
                        switch (checkoutStep) {
                          case CheckoutStep.delivery:
                            return const CheckoutDelivery();
                          case CheckoutStep.payment:
                            return const CheckoutPayment();
                          case CheckoutStep.summary:
                            return const CheckoutSummary();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, theme) {
                          return CheckoutContainer(
                            title: [
                              Text(
                                'TOTAL',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: theme.isDarkMode
                                      ? ColorManager.white
                                      : ColorManager.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  fontFamily: FontFamilyManager.montserrat,
                                ),
                              ),
                            ],
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Items total',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: theme.isDarkMode
                                            ? ColorManager.white
                                            : ColorManager.black,
                                      ),
                                    ),
                                    Text(
                                      'EGP ${context.read<UserBloc>().state.totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color: theme.isDarkMode
                                            ? ColorManager.white
                                            : ColorManager.black,
                                      ),
                                    ),
                                  ],
                                ),
                                BlocSelector<CheckoutCubit, CheckoutState,
                                    double?>(
                                  selector: (state) {
                                    return state.voucher;
                                  },
                                  builder: (context, voucher) {
                                    if (voucher != null) {
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Coupon Code',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: theme.isDarkMode
                                                      ? ColorManager.white
                                                      : ColorManager.black,
                                                ),
                                              ),
                                              Text(
                                                'EGP -$voucher%',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: theme.isDarkMode
                                                      ? ColorManager.white
                                                      : ColorManager.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Shipping Fees',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: theme.isDarkMode
                                            ? ColorManager.white
                                            : ColorManager.black,
                                      ),
                                    ),
                                    Text(
                                      'EGP 57.0',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color: theme.isDarkMode
                                            ? ColorManager.white
                                            : ColorManager.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Divider(
                                    color: theme.isDarkMode
                                        ? ColorManager.white
                                        : ColorManager.black38,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: theme.isDarkMode
                                            ? ColorManager.white
                                            : ColorManager.black,
                                      ),
                                    ),
                                    BlocSelector<CheckoutCubit, CheckoutState,
                                        double>(
                                      selector: (state) {
                                        return state.total;
                                      },
                                      builder: (context, total) {
                                        return Text(
                                          'EGP ${total.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w700,
                                            color: ColorManager.primary,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const CheckoutActions(),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('MODIFY CART'),
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                        ColorManager.indigo,
                                      ),
                                      overlayColor: MaterialStateProperty.all(
                                        ColorManager.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
