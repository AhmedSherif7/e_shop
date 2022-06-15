import 'package:equatable/equatable.dart';

import 'product.dart';

class UserData extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String governorate;
  final String city;
  final String street;
  final String postalCode;
  final String imageUrl;
  final List<Product> favorites;
  final List<Map<String, dynamic>> cartProducts;
  final String memberSince;

  const UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.governorate,
    required this.city,
    required this.street,
    required this.postalCode,
    required this.imageUrl,
    required this.favorites,
    required this.cartProducts,
    required this.memberSince,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phone,
        governorate,
        city,
        street,
        postalCode,
        imageUrl,
        favorites,
        cartProducts,
        memberSince,
      ];

  UserData copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? governorate,
    String? city,
    String? street,
    String? postalCode,
    String? imageUrl,
    List<Product>? favorites,
    List<Map<String, dynamic>>? cartProducts,
    String? memberSince,
  }) {
    return UserData(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      imageUrl: imageUrl ?? this.imageUrl,
      favorites: favorites ?? this.favorites,
      cartProducts: cartProducts ?? this.cartProducts,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}
