import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_manager.dart';

class AuthLoadingWidget extends StatelessWidget {
  const AuthLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: 60,
      child: Center(
        child: LottieBuilder.asset(
          AssetJsonManager.authLoading,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
