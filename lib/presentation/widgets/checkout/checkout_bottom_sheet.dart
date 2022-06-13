import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../app/functions.dart';
import '../../blocs/checkout/checkout_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../custom_bottom_sheet.dart';
import '../custom_button.dart';
import '../loading_widget.dart';

class CheckoutBottomSheet extends StatelessWidget {
  const CheckoutBottomSheet({required this.price, Key? key}) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) =>
          previous.paymentStatus != current.paymentStatus,
      listener: (context, state) {
        if (state.paymentStatus == PaymentStatus.error) {
          showToast(
            message: state.errorMessage!,
            state: ToastStates.error,
          );
        } else if (state.paymentStatus == PaymentStatus.success) {
          showToast(
            message: 'Transaction Success',
            state: ToastStates.success,
          );
          Navigator.pop(context);

          final user = context.read<UserBloc>().state.user;
          context.read<CheckoutCubit>().makeOrder(
                governorate: user.governorate,
                city: user.city,
                street: user.street,
                postalCode: user.postalCode,
                products: user.cartProducts,
                totalPrice: context.read<CheckoutCubit>().state.total,
                shippingFees: 57,
              );
        }
      },
      child: CustomBottomSheet(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Pay $price EGP using',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: FontFamilyManager.nunitoSans,
                      color: state.isDarkMode
                          ? ColorManager.white
                          : ColorManager.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CardField(
                    dangerouslyGetFullCardDetails: true,
                    onCardChanged: (card) {
                      context.read<CheckoutCubit>().cardChanged(card);
                    },
                    style: const TextStyle(
                      fontFamily: FontFamilyManager.nunitoSans,
                      color: ColorManager.black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Card',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      contentPadding: const EdgeInsets.all(12.0),
                      fillColor: state.isDarkMode
                          ? ColorManager.white
                          : ColorManager.lightGrey300,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<CheckoutCubit, CheckoutState>(
                      buildWhen: (previous, current) =>
                          previous.paymentStatus != current.paymentStatus ||
                          previous.cardValidStatus != current.cardValidStatus,
                      builder: (context, state) {
                        final email = context.read<UserBloc>().state.user.email;
                        final phone = context.read<UserBloc>().state.user.phone;
                        final name =
                            '${context.read<UserBloc>().state.user.firstName} ${context.read<UserBloc>().state.user.lastName}';
                        if (state.paymentStatus == PaymentStatus.loading) {
                          return const LoadingWidget();
                        }
                        return CustomButton(
                          color: ColorManager.indigo,
                          height: 50.0,
                          onTap: state.cardValidStatus ?? false
                              ? () {
                                  context.read<CheckoutCubit>().makePayment(
                                        amount: price,
                                        email: email,
                                        name: name,
                                        phone: phone,
                                      );
                                }
                              : null,
                          title: 'PAY',
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// final theme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.dark(secondary: Colors.blue[200]!),
//   inputDecorationTheme: InputDecorationTheme(
//     focusColor: Colors.red,
//     filled: true,
//     floatingLabelBehavior: FloatingLabelBehavior.always,
//     contentPadding: const EdgeInsets.symmetric(
//       vertical: 16.0,
//       horizontal: 12.0,
//     ),
//     hintStyle: TextStyle(color: Colors.blue[100]),
//     border: UnderlineInputBorder(
//       borderSide: BorderSide(color: Colors.blue[100]!),
//     ),
//     isCollapsed: true,
//   ),
// );
