class Constants {
  static const cachedUserIdKey = 'user_id';
  static const cachedWatchOnBoardKey = 'on_board';
  static const isDarkMode = 'is_dark_mode';
  static const String basePaymentUrl = 'https://api.stripe.com/v1';
  static const String paymentKey =
      'pk_test_51Kzn8tDMrG4wr6hDT5Z3YvnHcNoZWKs5pybqR8Z3FiqgFimvGXsIMJdEx2xm6V4vMf8gw6AsrAoQzFWhaPbu8UZ100HCEzetjG';
  static const String paymentSecretKey =
      'sk_test_51Kzn8tDMrG4wr6hD0zuI7WgfarZoCqCdzFgn1mmk2x3KCcqPcf0WBZzzEzr5xyJhLJUfzLvJ7fqHyXGX6Wp3zNFW00LQjpiAoe';
  static const String paymentIntentEndPoint = '/payment_intents';
  static const String chargeCardOffSessionEndPoint = '/charge-card-off-session';
  static String applicationJson = 'application/json';
  static String applicationUrlEncoded = 'application/x-www-form-urlencoded';
  static const int timeOut = 60 * 1000; // 1 minute
}
