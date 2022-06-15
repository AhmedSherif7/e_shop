part of 'user_bloc.dart';

enum FavoriteStatus {
  addedToFavoritesSuccess,
  addedToFavoritesError,
  removedFromFavoritesSuccess,
  removedFromFavoritesError,
}

enum CartStatus {
  addedToCartSuccess,
  addedToCartError,
  removedFromCartSuccess,
  removedFromCartError,
}

enum UserDataStatus {
  loading,
  success,
  error,
  logoutSuccess,
  logoutError,
}

@immutable
class UserState extends Equatable {
  final UserData user;
  final UserDataStatus userDataStatus;
  final FavoriteStatus? favoriteStatus;
  final CartStatus? cartStatus;
  final int totalCartProducts;
  final double totalPrice;
  final String? message;
  final bool notifyCartChange;

  const UserState({
    this.user = const UserData(
      id: emptyString,
      email: emptyString,
      firstName: emptyString,
      lastName: emptyString,
      phone: emptyString,
      governorate: emptyString,
      city: emptyString,
      street: emptyString,
      postalCode: emptyString,
      imageUrl: emptyString,
      favorites: [],
      cartProducts: [],
      memberSince: emptyString,
    ),
    this.userDataStatus = UserDataStatus.loading,
    this.favoriteStatus,
    this.cartStatus,
    this.totalCartProducts = 0,
    this.totalPrice = 0.0,
    this.message,
    this.notifyCartChange = true,
  });

  @override
  List<Object?> get props => [
        user,
        userDataStatus,
        favoriteStatus,
        cartStatus,
        totalCartProducts,
        totalPrice,
        notifyCartChange,
      ];

  UserState copyWith({
    UserData? user,
    UserDataStatus? userDataStatus,
    FavoriteStatus? favoriteStatus,
    CartStatus? cartStatus,
    String? message,
    double? totalPrice,
    int? totalCartProducts,
    bool? notifyCartChange,
  }) {
    return UserState(
      user: user ?? this.user,
      userDataStatus: userDataStatus ?? this.userDataStatus,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      cartStatus: cartStatus ?? this.cartStatus,
      totalCartProducts: totalCartProducts ?? this.totalCartProducts,
      totalPrice: totalPrice ?? this.totalPrice,
      message: message ?? this.message,
      notifyCartChange: notifyCartChange ?? this.notifyCartChange,
    );
  }
}
