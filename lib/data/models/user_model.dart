import '../../domain/entities/user.dart';
import '../mappers/mapper.dart';
import 'product_model.dart';

class UserDataModel extends UserData {
  const UserDataModel({
    required String id,
    required String email,
    String firstName = emptyString,
    String lastName = emptyString,
    String phone = emptyString,
    String governorate = emptyString,
    String city = emptyString,
    String street = emptyString,
    String postalCode = emptyString,
    String imageUrl = emptyString,
    List<ProductModel> favorites = const [],
    List<Map<String, dynamic>> cartProducts = const [],
    required String memberSince,
  }) : super(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          governorate: governorate,
          city: city,
          street: street,
          postalCode: postalCode,
          imageUrl: imageUrl,
          favorites: favorites,
          cartProducts: cartProducts,
          memberSince: memberSince,
        );

  factory UserDataModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      final List<ProductModel> favorites = [];
      if (json['favorites'] != null) {
        final favoritesJson = json['favorites'];
        for (var product in favoritesJson) {
          favorites.add(ProductModel.fromJson(product));
        }
      }

      final List<Map<String, dynamic>> cartProducts = [];
      if (json['cartProducts'] != null) {
        final cartProductsJson = json['cartProducts'];
        for (var productMap in cartProductsJson) {
          cartProducts.add({
            'product': ProductModel.fromJson(productMap['product']),
            'count': productMap['count'],
          });
        }
      }

      return UserDataModel(
        id: (json['id'] as String?).orEmpty(),
        email: (json['email'] as String?).orEmpty(),
        firstName: (json['firstName'] as String?).orEmpty(),
        lastName: (json['lastName'] as String?).orEmpty(),
        phone: (json['phone'] as String?).orEmpty(),
        governorate: (json['governorate'] as String?).orEmpty(),
        city: (json['city'] as String?).orEmpty(),
        street: (json['street'] as String?).orEmpty(),
        postalCode: (json['postalCode'] as String?).orEmpty(),
        imageUrl: (json['imageUrl'] as String?).orEmpty(),
        favorites: favorites,
        cartProducts: cartProducts,
        memberSince: (json['memberSince'] as String?).orEmpty(),
      );
    }
    return const UserDataModel(
      id: emptyString,
      email: emptyString,
      memberSince: emptyString,
    );
  }

  Map<String, dynamic> toJson() {
    final favorites = this
        .favorites
        .map((product) => (product as ProductModel).toJson())
        .toList();

    final cartProducts = this.cartProducts.map((productMap) {
      return (productMap['product'] as ProductModel).toJson();
    }).toList();

    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'governorate': governorate,
      'city': city,
      'street': street,
      'postalCode': postalCode,
      'imageUrl': imageUrl,
      'favorites': favorites,
      'cartProducts': cartProducts,
      'memberSince': memberSince,
    };
  }
}
