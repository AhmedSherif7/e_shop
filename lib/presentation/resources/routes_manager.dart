import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/constants.dart';
import '../../app/di.dart';
import '../blocs/user/user_bloc.dart';
import '../screens/checkout_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_layout.dart';
import '../screens/login_screen.dart';
import '../screens/on_boarding_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/register_screen.dart';
import '../screens/search_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/user_info_screen.dart';

class Routes {
  static const String splash = '/';
  static const String onBoarding = '/onboarding';
  static const String login = '/login';
  static const String forgotPassword = '/forgotPassword';
  static const String register = '/register';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String orders = '/orders';
  static const String userInfo = '/userInfo';
  static const String search = '/search';
  static const String checkout = '/checkout';
}

class RouteGenerator {
  static Route<dynamic>? getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splash:
        return PageTransition(
          child: Builder(
            builder: (context) {
              _getScreen(context);
              return SplashScreen(
                logout: routeSettings.arguments as bool? ?? false,
              );
            },
          ),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case Routes.onBoarding:
        initOnBoardingModule();
        return PageTransition(
          child: const OnBoardingScreen(),
          type: PageTransitionType.size,
          alignment: Alignment.bottomCenter,
        );
      case Routes.login:
        initLoginModule();
        return PageTransition(
          child: const LoginScreen(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case Routes.register:
        initRegisterModule();
        return PageTransition(
          child: const RegisterScreen(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case Routes.home:
        initHomeModule();
        return PageTransition(
          child: const HomeLayout(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case Routes.search:
        initSearchModule();
        return PageTransition(
          child: BlocProvider<UserBloc>.value(
            value: routeSettings.arguments! as UserBloc,
            child: const SearchScreen(),
          ),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case Routes.favorites:
        return PageTransition(
          child: BlocProvider<UserBloc>.value(
            value: routeSettings.arguments! as UserBloc,
            child: const FavoritesScreen(),
          ),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case Routes.orders:
        initUserOrdersModule();
        return PageTransition(
          child: const OrdersScreen(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case Routes.userInfo:
        initUserInfoModule();
        return PageTransition(
          child: BlocProvider<UserBloc>.value(
            value: routeSettings.arguments! as UserBloc,
            child: const UserInfoScreen(),
          ),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
      case Routes.checkout:
        initCheckoutModule();
        return PageTransition(
          child: BlocProvider<UserBloc>.value(
            value: routeSettings.arguments! as UserBloc,
            child: const CheckoutScreen(),
          ),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
        );
    }
    return null;
  }

  static Future<void> _getScreen(BuildContext context) async {
    await Firebase.initializeApp();
    Stripe.publishableKey = Constants.paymentKey;
    await Stripe.instance.applySettings();
    final sharedPreferences = sl<SharedPreferences>();
    if (sharedPreferences.containsKey(Constants.cachedUserIdKey) &&
        FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      if (sharedPreferences.containsKey(Constants.cachedWatchOnBoardKey)) {
        Navigator.pushReplacementNamed(context, Routes.login);
      } else {
        Navigator.pushReplacementNamed(context, Routes.onBoarding);
      }
    }
  }
}
