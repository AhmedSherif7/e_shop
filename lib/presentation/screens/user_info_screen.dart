import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ionicons/ionicons.dart';

import '../../app/di.dart';
import '../../app/functions.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/user_info/user_info_cubit.dart';
import '../resources/colors_manager.dart';
import '../widgets/loading_widget.dart';
import '../widgets/profile/address_container.dart';
import '../widgets/profile/image_widget.dart';
import '../widgets/profile/user_info_app_bar_leading.dart';
import '../widgets/profile/user_info_app_bar_title.dart';
import '../widgets/profile/user_info_custom_text_field.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final firstNameController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final lastNameController = TextEditingController();
  final lastNameFocusNode = FocusNode();
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();

  final governorateController = TextEditingController();
  final governorateFocusNode = FocusNode();
  final cityController = TextEditingController();
  final cityFocusNode = FocusNode();
  final streetController = TextEditingController();
  final streetFocusNode = FocusNode();
  final postalCodeController = TextEditingController();
  final postalCodeFocusNode = FocusNode();

  @override
  void initState() {
    firstNameController.text = context.read<UserBloc>().state.user.firstName;
    lastNameController.text = context.read<UserBloc>().state.user.lastName;
    emailController.text = context.read<UserBloc>().state.user.email;
    phoneController.text = context.read<UserBloc>().state.user.phone;
    governorateController.text =
        context.read<UserBloc>().state.user.governorate;
    cityController.text = context.read<UserBloc>().state.user.city;
    streetController.text = context.read<UserBloc>().state.user.street;
    postalCodeController.text = context.read<UserBloc>().state.user.postalCode;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    firstNameFocusNode.dispose();
    lastNameController.dispose();
    lastNameFocusNode.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    governorateController.dispose();
    governorateFocusNode.dispose();
    cityController.dispose();
    cityFocusNode.dispose();
    streetController.dispose();
    streetFocusNode.dispose();
    postalCodeController.dispose();
    postalCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserInfoCubit>(
      create: (_) => sl<UserInfoCubit>(),
      child: BlocConsumer<UserInfoCubit, UserInfoState>(
        listenWhen: (previous, current) {
          return previous.updateStatus != current.updateStatus ||
              previous.screenStatus != current.screenStatus;
        },
        listener: (context, state) {
          if (state.screenStatus == ScreenStatus.viewing) {
            final user = context.read<UserBloc>().state.user;
            firstNameController.text = user.firstName;
            lastNameController.text = user.lastName;
            emailController.text = user.email;
            phoneController.text = user.phone;
            governorateController.text = user.governorate;
            cityController.text = user.city;
            streetController.text = user.street;
            postalCodeController.text = user.postalCode;
          }

          if (state.formStatus == FormzStatus.invalid) {
            showToast(
              message: state.errorMessage!,
              state: ToastStates.error,
            );
          }

          if (state.updateStatus == UpdateStatus.success) {
            context.read<UserBloc>().add(UserDataFetched());

            showToast(
              message: 'Updated information successfully',
              state: ToastStates.success,
            );
          } else if (state.updateStatus == UpdateStatus.error) {
            showToast(
              message: state.errorMessage!,
              state: ToastStates.error,
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.screenStatus != current.screenStatus,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: UserInfoAppBarLeading(screenStatus: state.screenStatus),
              title: UserInfoAppBarTitle(screenStatus: state.screenStatus),
              actions: [
                IconButton(
                  onPressed: state.screenStatus == ScreenStatus.loading
                      ? null
                      : () {
                          if (state.screenStatus == ScreenStatus.viewing ||
                              state.screenStatus == ScreenStatus.infoUpdated) {
                            context.read<UserInfoCubit>().startEditing();
                          } else {
                            FocusScope.of(context).unfocus();
                            context.read<UserInfoCubit>().saveData(
                                  firstNameVal: firstNameController.text,
                                  lastNameVal: lastNameController.text,
                                  emailVal: emailController.text,
                                  phoneVal: phoneController.text,
                                  governorateVal: governorateController.text,
                                  cityVal: cityController.text,
                                  streetVal: streetController.text,
                                  postalCodeVal: postalCodeController.text,
                                );
                          }
                        },
                  icon: Icon(
                    state.screenStatus == ScreenStatus.viewing ||
                            state.screenStatus == ScreenStatus.infoUpdated
                        ? Ionicons.create_outline
                        : Ionicons.save_outline,
                  ),
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: state.screenStatus == ScreenStatus.loading,
              builder: (context) {
                return const Center(
                  child: LoadingWidget(),
                );
              },
              fallback: (context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            BlocBuilder<ThemeCubit, ThemeState>(
                              builder: (context, theme) {
                                return CircleAvatar(
                                  radius: 68.0,
                                  backgroundColor: theme.isDarkMode
                                      ? ColorManager.white
                                      : ColorManager.black,
                                  child: BlocSelector<UserInfoCubit,
                                      UserInfoState, String?>(
                                    selector: (state) {
                                      return state.newImagePath;
                                    },
                                    builder: (context, imagePath) {
                                      return BlocSelector<UserInfoCubit,
                                          UserInfoState, ImageStatus>(
                                        selector: (state) {
                                          return state.imageStatus;
                                        },
                                        builder: (context, imageStatus) {
                                          if (state.screenStatus ==
                                                  ScreenStatus.viewing ||
                                              imageStatus ==
                                                  ImageStatus.initial) {
                                            return UserAvatarImage(
                                              NetworkImage(
                                                context
                                                    .read<UserBloc>()
                                                    .state
                                                    .user
                                                    .imageUrl,
                                              ),
                                            );
                                          } else {
                                            if (imageStatus ==
                                                ImageStatus.error) {
                                              showToast(
                                                message: state.errorMessage!,
                                                state: ToastStates.error,
                                              );

                                              return UserAvatarImage(
                                                NetworkImage(
                                                  context
                                                      .read<UserBloc>()
                                                      .state
                                                      .user
                                                      .imageUrl,
                                                ),
                                              );
                                            } else {
                                              return UserAvatarImage(
                                                FileImage(
                                                  File(imagePath!),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            if (state.screenStatus == ScreenStatus.editing)
                              Positioned(
                                bottom: 2.0,
                                right: 0.0,
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundColor: ColorManager.blue,
                                  child: IconButton(
                                    onPressed: () {
                                      context
                                          .read<UserInfoCubit>()
                                          .changeImage();
                                    },
                                    icon: const Icon(
                                      Ionicons.camera_sharp,
                                      size: 28.0,
                                      color: ColorManager.black,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: BlocSelector<UserInfoCubit, UserInfoState,
                                  bool>(
                                selector: (state) {
                                  return state.firstName.valid;
                                },
                                builder: (context, firstNameValid) {
                                  return UserInfoCustomTextField(
                                    controller: firstNameController,
                                    label: 'First Name',
                                    maxLength: 20,
                                    enabled: state.screenStatus ==
                                        ScreenStatus.editing,
                                    textInputType: TextInputType.name,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(lastNameFocusNode);
                                    },
                                    errorText: state.formStatus ==
                                                FormzStatus.invalid &&
                                            !firstNameValid
                                        ? 'first name can not be empty'
                                        : null,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: BlocSelector<UserInfoCubit, UserInfoState,
                                  bool>(
                                selector: (state) {
                                  return state.lastName.valid;
                                },
                                builder: (context, lastNameValid) {
                                  return UserInfoCustomTextField(
                                    controller: lastNameController,
                                    focusNode: lastNameFocusNode,
                                    label: 'Last Name',
                                    maxLength: 20,
                                    textInputType: TextInputType.name,
                                    enabled: state.screenStatus ==
                                        ScreenStatus.editing,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(emailFocusNode);
                                    },
                                    errorText: state.formStatus ==
                                                FormzStatus.invalid &&
                                            !lastNameValid
                                        ? 'last name can not be empty'
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        BlocSelector<UserInfoCubit, UserInfoState, bool>(
                          selector: (state) {
                            return state.email.valid;
                          },
                          builder: (context, emailValid) {
                            return UserInfoCustomTextField(
                              controller: emailController,
                              focusNode: emailFocusNode,
                              label: 'E-mail',
                              maxLength: 35,
                              textInputType: TextInputType.emailAddress,
                              enabled:
                                  state.screenStatus == ScreenStatus.editing,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(phoneFocusNode);
                              },
                              errorText:
                                  state.formStatus == FormzStatus.invalid &&
                                          !emailValid
                                      ? 'invalid email'
                                      : null,
                            );
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            CountryCodePicker(
                              initialSelection: 'EG',
                              favorite: const ['+20', 'EG'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              enabled: false,
                              padding: const EdgeInsets.all(0.0),
                            ),
                            Expanded(
                              child: BlocSelector<UserInfoCubit, UserInfoState,
                                  bool>(
                                selector: (state) {
                                  return state.phone.valid;
                                },
                                builder: (context, phoneValid) {
                                  return UserInfoCustomTextField(
                                    controller: phoneController,
                                    focusNode: phoneFocusNode,
                                    label: 'Phone',
                                    textInputType: TextInputType.phone,
                                    maxLength: 10,
                                    enabled: state.screenStatus ==
                                        ScreenStatus.editing,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(governorateFocusNode);
                                    },
                                    errorText: state.formStatus ==
                                                FormzStatus.invalid &&
                                            !phoneValid
                                        ? 'invalid phone number'
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        AddressContainer(
                          state: state,
                          governorateController: governorateController,
                          governorateFocusNode: governorateFocusNode,
                          cityController: cityController,
                          cityFocusNode: cityFocusNode,
                          streetController: streetController,
                          streetFocusNode: streetFocusNode,
                          postalCodeController: postalCodeController,
                          postalCodeFocusNode: postalCodeFocusNode,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
