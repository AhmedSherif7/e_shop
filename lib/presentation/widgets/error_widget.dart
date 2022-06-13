import 'package:flutter/material.dart';

import '../resources/font_manager.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({this.error = 'Error', Key? key}) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Text(
      error,
      style: const TextStyle(
        fontSize: 26.0,
        fontFamily: FontFamilyManager.nunitoSans,
      ),
    );
  }
}
