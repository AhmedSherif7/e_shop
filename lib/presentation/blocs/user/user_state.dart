part of 'user_bloc.dart';

enum UserProductStatus {
  addedToFavoritesSuccess,
  addedToFavoritesError,
  removedFromFavoritesSuccess,
  removedFromFavoritesError,
  addedToCartSuccess,
  addedToCartError,
  removedFromCartSuccess,
  removedFromCartError,
  changeCartProductCountSuccess,
  changeCartProductCountError,
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
  final UserProductStatus? userProductStatus;
  final int totalCartProducts;
  final double totalPrice;
  final String? message;

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
    this.userProductStatus,
    this.totalCartProducts = 0,
    this.totalPrice = 0.0,
    this.message,
  });

  @override
  List<Object?> get props => [
        user,
        userDataStatus,
        userProductStatus,
        totalCartProducts,
        totalPrice,
      ];

  UserState copyWith({
    UserData? user,
    UserDataStatus? userDataStatus,
    UserProductStatus? userProductStatus,
    String? message,
    double? totalPrice,
    int? totalCartProducts,
  }) {
    return UserState(
      user: user ?? this.user,
      userDataStatus: userDataStatus ?? this.userDataStatus,
      userProductStatus: userProductStatus ?? this.userProductStatus,
      totalCartProducts: totalCartProducts ?? this.totalCartProducts,
      totalPrice: totalPrice ?? this.totalPrice,
      message: message ?? this.message,
    );
  }
}
