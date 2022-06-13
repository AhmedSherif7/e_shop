import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../app/di.dart';
import '../../app/functions.dart';
import '../blocs/register/register_cubit.dart';
import '../resources/assets_manager.dart';
import '../resources/colors_manager.dart';
import '../resources/routes_manager.dart';
import '../widgets/auth/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmedPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmedPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (_) => sl<RegisterCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: ColorManager.transparentPrimary,
          toolbarHeight: 0.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorManager.transparentPrimaryStatusBarColor,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetImageManager.authBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: ColorManager.transparentPrimary,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100.0,
                    ),
                    const Text(
                      'Welcome to E-Shop',
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            offset: Offset(0, 5),
                            blurRadius: 10.0,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    const Text(
                      'Sign up and start \n shopping now',
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 24.0,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    BlocConsumer<RegisterCubit, RegisterState>(
                      listenWhen: (previous, current) =>
                          previous.status != current.status,
                      listener: (context, state) {
                        if (state.status.isSubmissionFailure) {
                          showCustomDialog(
                            context: context,
                            alertType: AlertType.none,
                            title: 'Sign Up Error',
                            desc: state.errorMessage!,
                            lottie: AssetJsonManager.error,
                            buttons: [
                              DialogButton(
                                child: const Text(
                                  "Dismiss",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                                color: ColorManager.grey,
                              ),
                            ],
                          );
                        }

                        if (state.status.isSubmissionSuccess) {
                          showCustomDialog(
                            context: context,
                            alertType: AlertType.none,
                            title: 'Sign Up Success',
                            desc: 'Go to login ?',
                            lottie: AssetJsonManager.success,
                            buttons: [
                              DialogButton(
                                child: const Text(
                                  'Ok',
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.login,
                                  );
                                },
                                color: ColorManager.green,
                              ),
                              DialogButton(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                color: ColorManager.grey,
                              ),
                            ],
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                          ),
                          child: RegisterForm(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            passwordFocusNode: _passwordFocusNode,
                            confirmedPasswordFocusNode:
                                _confirmedPasswordFocusNode,
                            confirmPasswordController:
                                _repeatPasswordController,
                          ),
                        );
                      },
                    ),
                    BlocSelector<RegisterCubit, RegisterState, FormzStatus>(
                      selector: (state) {
                        return state.status;
                      },
                      builder: (context, status) {
                        if (status != FormzStatus.submissionInProgress) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already a User? ',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromRGBO(255, 255, 255, 0.8),
                                  fontSize: 14.0,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.login,
                                  );
                                },
                                child: const Text(
                                  'Login instead',
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
