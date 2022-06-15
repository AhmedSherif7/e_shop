part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserDataFetched extends UserEvent {}

class UserProductFavoriteToggled extends UserEvent {
  final List<Product> favorites;
  final Product product;

  UserProductFavoriteToggled(this.favorites, this.product);
}

class UserProductCartToggled extends UserEvent {
  final List<Map<String, dynamic>> cartProducts;
  final Product product;

  UserProductCartToggled(this.cartProducts, this.product);
}

class UserCartProductCountChanged extends UserEvent {
  final List<Map<String, dynamic>> cartProducts;
  final String productId;
  final bool isAdd;

  UserCartProductCountChanged(this.cartProducts, this.productId, this.isAdd);
}

class UserDataChanged extends UserEvent {
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String governorate;
  final String city;
  final String street;
  final String postalCode;

  UserDataChanged({
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.governorate,
    required this.city,
    required this.street,
    required this.postalCode,
  });
}

class UserOrderCreated extends UserEvent {}

class UserLoggedOut extends UserEvent {}
