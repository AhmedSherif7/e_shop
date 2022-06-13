import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/routes_manager.dart';
import 'checkout_address_field.dart';
import 'checkout_container.dart';

class CheckoutAddress extends StatelessWidget {
  const CheckoutAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return CheckoutContainer(
          title: [
            Text(
              'ADDRESS DETAILS',
              textAlign: TextAlign.start,
              style: TextStyle(
                color:
                    state.isDarkMode ? ColorManager.white : ColorManager.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                fontFamily: FontFamilyManager.montserrat,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.userInfo,
                );
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
          child: Column(
            children: [
              BlocSelector<UserBloc, UserState, String>(
                selector: (state) {
                  return state.user.governorate;
                },
                builder: (context, governorate) {
                  final controller = TextEditingController()
                    ..text = governorate;
                  return CheckoutAddressField(
                    controller: controller,
                    label: 'Governorate',
                  );
                },
              ),
              BlocSelector<UserBloc, UserState, String>(
                selector: (state) {
                  return state.user.city;
                },
                builder: (context, city) {
                  final controller = TextEditingController()..text = city;
                  return CheckoutAddressField(
                    controller: controller,
                    label: 'City',
                  );
                },
              ),
              BlocSelector<UserBloc, UserState, String>(
                selector: (state) {
                  return state.user.street;
                },
                builder: (context, street) {
                  final controller = TextEditingController()..text = street;
                  return CheckoutAddressField(
                    controller: controller,
                    label: 'Street',
                  );
                },
              ),
              BlocSelector<UserBloc, UserState, String>(
                selector: (state) {
                  return state.user.phone;
                },
                builder: (context, phone) {
                  final controller = TextEditingController()..text = '0$phone';
                  return CheckoutAddressField(
                    controller: controller,
                    label: 'Phone',
                  );
                },
              ),
              BlocSelector<UserBloc, UserState, String>(
                selector: (state) {
                  return state.user.postalCode;
                },
                builder: (context, postalCode) {
                  final controller = TextEditingController()..text = postalCode;
                  return CheckoutAddressField(
                    controller: controller,
                    label: 'Postal Code',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
