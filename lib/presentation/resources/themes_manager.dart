import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'font_manager.dart';
import 'colors_manager.dart';

class ThemeManager {
  final light = ThemeData(
    scaffoldBackgroundColor: ColorManager.lightBackground,
    primaryColor: ColorManager.primary,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: ColorManager.primary,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: ColorManager.black,
      ),
      titleTextStyle: TextStyle(
        color: ColorManager.black,
        fontSize: 22.0,
        fontFamily: FontFamilyManager.montserrat,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: ColorManager.lightBackground,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: ColorManager.lightBackground,
      ),
    ),
    textTheme: const TextTheme(
      headline6: TextStyle(
        color: ColorManager.black,
        fontWeight: FontWeight.bold,
        fontFamily: FontFamilyManager.nunitoSans,
      ),
    ),
    cardColor: ColorManager.lightGrey100,
  );

  final dark = ThemeData(
    scaffoldBackgroundColor: ColorManager.black,
    primaryColor: ColorManager.primary,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: ColorManager.primary,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: ColorManager.white,
      ),
      titleTextStyle: TextStyle(
        color: ColorManager.white,
        fontSize: 22.0,
        fontFamily: FontFamilyManager.montserrat,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: ColorManager.black,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: ColorManager.black,
      ),
    ),
    textTheme: const TextTheme(
      headline6: TextStyle(
        color: ColorManager.white,
        fontWeight: FontWeight.bold,
        fontFamily: FontFamilyManager.nunitoSans,
      ),
    ),
    cardColor: ColorManager.grey,
  );
}
