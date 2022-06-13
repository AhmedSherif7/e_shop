import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/checkout/checkout_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import 'checkout_container.dart';

class CheckoutVoucher extends StatelessWidget {
  const CheckoutVoucher({
    required this.voucherController,
    Key? key,
  }) : super(key: key);

  final TextEditingController voucherController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, theme) {
        return CheckoutContainer(
          title: [
            Text(
              'VOUCHER',
              textAlign: TextAlign.start,
              style: TextStyle(
                color:
                    theme.isDarkMode ? ColorManager.white : ColorManager.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                fontFamily: FontFamilyManager.montserrat,
              ),
            ),
          ],
          child: BlocBuilder<CheckoutCubit, CheckoutState>(
            buildWhen: (previous, current) =>
                previous.voucherStatus != current.voucherStatus,
            builder: (context, state) {
              if (state.voucherStatus == VoucherStatus.valid) {
                voucherController.clear();
              }
              return Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: state.voucherStatus == VoucherStatus.loading
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.baseline,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: theme.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                        ),
                        controller: voucherController,
                        decoration: InputDecoration(
                          label: const Text('Coupon Code'),
                          labelStyle: TextStyle(
                            color: theme.isDarkMode
                                ? ColorManager.white
                                : ColorManager.black38,
                          ),
                          errorText:
                              state.voucherStatus == VoucherStatus.invalid ||
                                      state.voucherStatus ==
                                          VoucherStatus.addedBefore
                                  ? state.errorMessage!
                                  : null,
                          floatingLabelStyle: TextStyle(
                            color: theme.isDarkMode
                                ? ColorManager.white
                                : ColorManager.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: ColorManager.lightGrey350,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: ColorManager.lightGrey350,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: ColorManager.lightGrey350,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ConditionalBuilder(
                    condition: state.voucherStatus == VoucherStatus.loading,
                    builder: (context) {
                      return const CircularProgressIndicator();
                    },
                    fallback: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          context
                              .read<CheckoutCubit>()
                              .addVoucher(voucherController.text);
                        },
                        child: const Text('Use'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            ColorManager.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
