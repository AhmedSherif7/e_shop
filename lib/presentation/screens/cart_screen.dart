import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user/user_bloc.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';
import '../resources/routes_manager.dart';
import '../widgets/cart/cart_products_list_view.dart';
import '../widgets/cart/empty_cart.dart';
import '../widgets/custom_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: ColorManager.primary,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: ColorManager.white,
                    fontSize: 20.0,
                  ),
                ),
                BlocSelector<UserBloc, UserState, int>(
                  selector: (state) {
                    return state.totalCartProducts;
                  },
                  builder: (context, totalCartProducts) {
                    return Text(
                      '$totalCartProducts items',
                      style: const TextStyle(
                        color: ColorManager.white,
                        fontSize: 20.0,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          BlocSelector<UserBloc, UserState, int>(
            selector: (state) {
              return state.totalCartProducts;
            },
            builder: (context, cartProducts) {
              return ConditionalBuilder(
                condition: cartProducts > 0,
                builder: (context) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CartProductsListView(
                          context.read<UserBloc>().state.user.cartProducts,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 80.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Total Price',
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: 24.0,
                                  fontFamily: FontFamilyManager.montserrat,
                                ),
                              ),
                              BlocSelector<UserBloc, UserState, double>(
                                selector: (state) {
                                  return state.totalPrice;
                                },
                                builder: (context, totalPrice) {
                                  return Text(
                                    'EGP ${totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: ColorManager.white,
                                      fontSize: 24.0,
                                      fontFamily: FontFamilyManager.nunitoSans,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.indigo,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      CustomButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.checkout,
                            arguments: context.read<UserBloc>(),
                          );
                        },
                        title: 'Checkout',
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  );
                },
                fallback: (context) {
                  return const EmptyCart();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
