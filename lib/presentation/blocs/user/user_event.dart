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

class UserLoggedOut extends UserEvent {}
