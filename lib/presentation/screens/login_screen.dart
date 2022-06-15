import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../app/di.dart';
import '../../app/functions.dart';
import '../blocs/login/login_cubit.dart';
import '../resources/assets_manager.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';
import '../resources/routes_manager.dart';
import '../widgets/auth/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => sl<LoginCubit>(),
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
                  horizontal: 28.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 130.0,
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
                      height: 40.0,
                    ),
                    const Text(
                      'Login to your account',
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 24.0,
                        fontFamily: FontFamilyManager.montserrat,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                          ),
                          child: LoginForm(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            passwordFocusNode: _passwordFocusNode,
                          ),
                        ),
                        BlocConsumer<LoginCubit, LoginState>(
                          listenWhen: (previous, current) =>
                              previous.status != current.status,
                          listener: (context, state) {
                            if (state.status.isSubmissionFailure) {
                              showCustomDialog(
                                context: context,
                                alertType: AlertType.none,
                                title: 'Login Error',
                                desc: state.errorMessage!,
                                lottie: AssetJsonManager.error,
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      'Dismiss',
                                      style: TextStyle(
                                        color: ColorManager.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    width: 120,
                                    color: ColorManager.grey,
                                  ),
                                ],
                              );
                            }

                            if (state.status.isSubmissionSuccess) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.home,
                                (route) => false,
                              );
                            }
                          },
                          buildWhen: (previous, current) =>
                              previous.status != current.status,
                          builder: (context, state) {
                            if (!state.status.isSubmissionInProgress) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Forgot your password? ',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.8,
                                          ),
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: const Text(
                                          'Reset password',
                                          style: TextStyle(
                                            color: ColorManager.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'New User? ',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.8,
                                          ),
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            Routes.register,
                                          );
                                        },
                                        child: const Text(
                                          'Sign up now',
                                          style: TextStyle(
                                            color: ColorManager.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
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
