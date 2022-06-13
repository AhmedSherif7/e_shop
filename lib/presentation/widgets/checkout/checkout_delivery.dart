import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import 'checkout_address.dart';
import 'checkout_container.dart';

class CheckoutDelivery extends StatelessWidget {
  const CheckoutDelivery({Key? key}) : super(key: key);

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
                    'SHIPMENT DETAILS',
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
                child: ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount:
                      context.read<UserBloc>().state.user.cartProducts.length,
                  itemBuilder: (context, index) {
                    var product =
                        context.read<UserBloc>().state.user.cartProducts[index];
                    return ListTile(
                      leading: Text(
                        '${product['count']}x',
                        style: TextStyle(
                          color: state.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                        ),
                      ),
                      title: Text(
                        product['product'].name,
                        style: TextStyle(
                          color: state.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                        ),
                      ),
                      subtitle: Text(
                        product['product'].description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: state.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 5.0,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
