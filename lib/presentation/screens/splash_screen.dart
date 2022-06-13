import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/assets_manager.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({this.logout = false, Key? key}) : super(key: key);

  final bool logout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: ColorManager.splash,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AssetImageManager.splash,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Align(
            alignment: Alignment(0, -0.75),
            child: Text(
              'Welcome to E-Shop',
              style: TextStyle(
                fontSize: 32.0,
                color: ColorManager.white,
                fontFamily: FontFamilyManager.nunitoSans,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
