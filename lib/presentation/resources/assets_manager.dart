const String kImagePath = 'assets/images';
const String kJsonPath = 'assets/json';

class AssetImageManager {
  static const splash = '$kImagePath/splash.jpg';

  static const onBoardingBackground = '$kImagePath/onboarding_background.png';
  static const onBoardingFirstScreen =
      '$kImagePath/onboarding_first_screen.png';
  static const onBoardingSecondScreen =
      '$kImagePath/onboarding_second_screen.png';
  static const onBoardingThirdScreen =
      '$kImagePath/onboarding_third_screen.png';
  static const onBoardingFourthScreen =
      '$kImagePath/onboarding_fourth_screen.png';

  static const authBackground = '$kImagePath/auth_background.jpg';

  static const productPlaceHolder = '$kImagePath/product_place_holder.jpg';
}

class AssetJsonManager {
  static const success = '$kJsonPath/success.json';
  static const error = '$kJsonPath/error.json';
  static const loading = '$kJsonPath/loading.json';
  static const authLoading = '$kJsonPath/auth_loading.json';
  static const emptyCart = '$kJsonPath/empty_cart.json';
  static const emptyOrders = '$kJsonPath/empty_orders.json';
  static const emptyFavorites = '$kJsonPath/empty_favorites.json';
  static const emptySearch = '$kJsonPath/empty_search.json';
}
