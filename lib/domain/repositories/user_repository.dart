import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/error/failure.dart';
import '../entities/order.dart';
import '../entities/product.dart';
import '../entities/user.dart';
import '../use_cases/base_use_case.dart';

abstract class UserRepository {
  Future<Either<Failure, UserData>> getUserData();

  Future<Either<Failure, List<Product>>> addProductToFavorites(
    List<Product> favorites,
    Product product,
  );

  Future<Either<Failure,  List<Product>>> removeProductFromFavorites(
    List<Product> favorites,
    String productId,
  );

  Future<Either<Failure, List<Map<String, dynamic>>>> addProductToCart(
    List<Map<String, dynamic>> cartProducts,
    Product product,
  );

  Future<Either<Failure, List<Map<String, dynamic>>>> removeProductFromCart(
    List<Map<String, dynamic>> cartProducts,
    String productId,
  );

  Future<Either<Failure, List<Map<String, dynamic>>>> changeCartProductCount(
    List<Map<String, dynamic>> cartProducts,
    String productId,
    bool isAdd,
  );

  Future<Either<Failure, Position>> getUserLocation();

  Future<Either<Failure, Placemark>> getUserAddress(
      double longitude, double latitude);

  Future<Either<Failure, XFile>> getImageFromGallery();

  Future<Either<Failure, String>> updateUserData(Map<String, String> newData);

  Future<Either<Failure, Map<String, dynamic>>> addVoucher(String code);

  Future<Either<Failure, NoOutput>> makeOrder({
    required String governorate,
    required String city,
    required String street,
    required String postalCode,
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required String paymentMethod,
    required double voucher,
    required double shippingFees,
  });

  Future<Either<Failure, List<OrderData>>> getUserOrders();
}
