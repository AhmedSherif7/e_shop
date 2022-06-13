import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../resources/assets_manager.dart';

class ImageLoadError extends StatelessWidget {
  const ImageLoadError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 220.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AssetJsonManager.error,
            repeat: false,
            width: 120.0,
            height: 120.0,
          ),
        ],
      ),
    );
  }
}
