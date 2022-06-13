import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../presentation/resources/assets_manager.dart';
import '../presentation/resources/colors_manager.dart';

enum ToastStates {
  success,
  error,
  warning,
}

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.success:
      color = ColorManager.green;
      break;
    case ToastStates.error:
      color = ColorManager.red;
      break;
    case ToastStates.warning:
      color = ColorManager.amber;
      break;
  }

  return color;
}

void showToast({required String message, required ToastStates state}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: chooseToastColor(state),
    textColor: ColorManager.white,
    fontSize: 16.0,
  );
}

void toggleSnackBar({
  required BuildContext context,
  required String message,
  required bool success,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1200),
        action: SnackBarAction(
          textColor: ColorManager.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          label: 'Dismiss',
        ),
        backgroundColor: success ? ColorManager.green : ColorManager.red,
        content: Row(
          children: [
            Lottie.asset(
              success ? AssetJsonManager.success : AssetJsonManager.error,
              repeat: false,
              width: 50.0,
              height: 50.0,
            ),
            Flexible(
              child: Text(
                message,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ColorManager.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

void showCustomDialog({
  required BuildContext context,
  required AlertType alertType,
  required String title,
  required String desc,
  required String lottie,
  List<DialogButton> buttons = const [],
}) {
  Alert(
    context: context,
    type: alertType,
    title: title,
    desc: desc,
    content: Lottie.asset(
      lottie,
      repeat: false,
      width: 100.0,
      height: 100.0,
    ),
    style: const AlertStyle(
      animationType: AnimationType.grow,
      animationDuration: Duration(milliseconds: 400),
    ),
    buttons: buttons,
  ).show();
}
