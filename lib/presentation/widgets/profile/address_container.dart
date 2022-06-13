import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ionicons/ionicons.dart';

import '../../../app/functions.dart';
import '../../blocs/user_info/user_info_cubit.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import 'map_bottom_sheet.dart';
import 'user_info_custom_text_field.dart';

class AddressContainer extends StatelessWidget {
  const AddressContainer({
    required this.state,
    required this.governorateController,
    required this.governorateFocusNode,
    required this.cityController,
    required this.cityFocusNode,
    required this.streetController,
    required this.streetFocusNode,
    required this.postalCodeController,
    required this.postalCodeFocusNode,
    Key? key,
  }) : super(key: key);

  final UserInfoState state;
  final TextEditingController governorateController;
  final FocusNode governorateFocusNode;
  final TextEditingController cityController;
  final FocusNode cityFocusNode;
  final TextEditingController streetController;
  final FocusNode streetFocusNode;
  final TextEditingController postalCodeController;
  final FocusNode postalCodeFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoCubit, UserInfoState>(
      listenWhen: (previous, current) =>
          previous.addressStatus != current.addressStatus,
      listener: (context, state) {
        if (state.addressStatus == AddressStatus.error) {
          Navigator.pop(context);
          showToast(
            message: state.errorMessage!,
            state: ToastStates.error,
          );
        } else if (state.addressStatus == AddressStatus.success) {
          Navigator.pop(context);
          showToast(
            message: 'Address selected',
            state: ToastStates.success,
          );
          governorateController.text = state.placeMark!.administrativeArea!;
          cityController.text = state.placeMark!.name!;
          streetController.text = state.placeMark!.street!;
          postalCodeController.text = state.placeMark!.postalCode!;
        }
      },
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'Address',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: FontFamilyManager.montserrat,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: ColorManager.black38,
              ),
            ),
            child: Column(
              children: [
                BlocSelector<UserInfoCubit, UserInfoState, bool>(
                  selector: (state) {
                    return state.governorate.valid;
                  },
                  builder: (context, governorateValid) {
                    return UserInfoCustomTextField(
                      controller: governorateController,
                      focusNode: governorateFocusNode,
                      label: 'Governorate',
                      textInputType: TextInputType.streetAddress,
                      maxLength: 15,
                      enabled: state.screenStatus == ScreenStatus.editing,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(cityFocusNode);
                      },
                      errorText: state.formStatus == FormzStatus.invalid &&
                              !governorateValid
                          ? 'governorate can not be empty'
                          : null,
                    );
                  },
                ),
                BlocSelector<UserInfoCubit, UserInfoState, bool>(
                  selector: (state) {
                    return state.city.valid;
                  },
                  builder: (context, cityValid) {
                    return UserInfoCustomTextField(
                      controller: cityController,
                      focusNode: cityFocusNode,
                      label: 'City',
                      textInputType: TextInputType.streetAddress,
                      maxLength: 15,
                      enabled: state.screenStatus == ScreenStatus.editing,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(streetFocusNode);
                      },
                      errorText:
                          state.formStatus == FormzStatus.invalid && !cityValid
                              ? 'city can not be empty'
                              : null,
                    );
                  },
                ),
                BlocSelector<UserInfoCubit, UserInfoState, bool>(
                  selector: (state) {
                    return state.street.valid;
                  },
                  builder: (context, streetValid) {
                    return UserInfoCustomTextField(
                      controller: streetController,
                      focusNode: streetFocusNode,
                      label: 'Street',
                      textInputType: TextInputType.streetAddress,
                      maxLength: 35,
                      enabled: state.screenStatus == ScreenStatus.editing,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(postalCodeFocusNode);
                      },
                      errorText: state.formStatus == FormzStatus.invalid &&
                              !streetValid
                          ? 'street can not be empty'
                          : null,
                    );
                  },
                ),
                BlocSelector<UserInfoCubit, UserInfoState, bool>(
                  selector: (state) {
                    return state.postalCode.valid;
                  },
                  builder: (context, postalCodeValid) {
                    return UserInfoCustomTextField(
                      controller: postalCodeController,
                      focusNode: postalCodeFocusNode,
                      label: 'Postal Code',
                      textInputType: TextInputType.number,
                      maxLength: 10,
                      enabled: state.screenStatus == ScreenStatus.editing,
                      onFieldSubmitted: (_) {},
                      errorText: state.formStatus == FormzStatus.invalid &&
                              !postalCodeValid
                          ? 'postal code can not be empty'
                          : null,
                    );
                  },
                ),
                if (state.screenStatus == ScreenStatus.editing)
                  TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        builder: (_) {
                          return BlocProvider<UserInfoCubit>.value(
                            value: context.read<UserInfoCubit>(),
                            child: const MapBottomSheet(),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Ionicons.map,
                      color: ColorManager.indigo,
                    ),
                    label: const Text(
                      'or select address on map',
                      style: TextStyle(
                        color: ColorManager.indigo,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
