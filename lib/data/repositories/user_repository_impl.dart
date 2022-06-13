import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/use_cases/base_use_case.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';
import '../error/failure.dart';
import '../models/product_model.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserData>> getUserData() async {
    try {
      final userId = localDataSource.getCachedUserId();
      final user = await remoteDataSource.getUserData(userId);
      return Right(user);
    } catch (_) {
      return const Left(Failure(message: 'Failed to get data'));
    }
  }

  @override
  Future<Either<Failure, NoOutput>> addProductToFavorites(
      List<Product> favorites, Product product) async {
    try {
      final userId = localDataSource.getCachedUserId();
      final favoritesModel =
          favorites.map((product) => product as ProductModel).toList();
      await remoteDataSource.addProductToFavorites(
        userId,
        favoritesModel,
        product as ProductModel,
      );
      return Right(NoOutput());
    } catch (_) {
      return const Left(Failure(message: 'Failed to add product to favorites'));
    }
  }

  @override
  Future<Either<Failure, NoOutput>> removeProductFromFavorites(
      List<Product> favorites, String productId) async {
    try {
      final userId = localDataSource.getCachedUserId();
      final favoritesModel =
          favorites.map((product) => product as ProductModel).toList();
      await remoteDataSource.removeProductFromFavorites(
        userId,
        favoritesModel,
        productId,
      );
      return Right(NoOutput());
    } catch (_) {
      return const Left(
        Failure(message: 'Failed to remove product from favorites'),
      );
    }
  }

  @override
  Future<Either<Failure, NoOutput>> addProductToCart(
      List<Map<String, dynamic>> cartProducts, Product product) async {
    try {
      final userId = localDataSource.getCachedUserId();

      final cartProductsModel = cartProducts.map((productMap) {
        final product = productMap['product'] as ProductModel;
        final count = productMap['count'];
        return {
          'product': product,
          'count': count,
        };
      }).toList();

      await remoteDataSource.addProductToCart(
        userId,
        cartProductsModel,
        product as ProductModel,
      );
      return Right(NoOutput());
    } catch (_) {
      return const Left(
        Failure(message: 'Failed to add product to cart'),
      );
    }
  }

  @override
  Future<Either<Failure, NoOutput>> removeProductFromCart(
      List<Map<String, dynamic>> cartProducts, String productId) async {
    try {
      final userId = localDataSource.getCachedUserId();
      final cartProductsModel = cartProducts.map((productMap) {
        final product = productMap['product'] as ProductModel;
        final count = productMap['count'];
        return {
          'product': product,
          'count': count,
        };
      }).toList();

      await remoteDataSource.removeProductFromCart(
        userId,
        cartProductsModel,
        productId,
      );
      return Right(NoOutput());
    } catch (_) {
      return const Left(
        Failure(message: 'Failed to remove product from cart'),
      );
    }
  }

  @override
  Future<Either<Failure, NoOutput>> changeCartProductCount(
    List<Map<String, dynamic>> cartProducts,
    String productId,
    bool isAdd,
  ) async {
    try {
      final userId = localDataSource.getCachedUserId();
      await remoteDataSource.changeCartProductCount(
        userId,
        cartProducts,
        productId,
        isAdd,
      );
      return Right(NoOutput());
    } catch (_) {
      return const Left(
        Failure(message: 'Failed to change product count in cart'),
      );
    }
  }

  @override
  Future<Either<Failure, Position>> getUserLocation() async {
    try {
      final position = await remoteDataSource.getUserLocation();
      return Right(position);
    } on Failure catch (error) {
      return Left(error);
    } catch (_) {
      return const Left(Failure(message: 'Failed to get location'));
    }
  }

  @override
  Future<Either<Failure, Placemark>> getUserAddress(
    double longitude,
    double latitude,
  ) async {
    try {
      final address =
          await remoteDataSource.getUserAddress(longitude, latitude);
      return Right(address);
    } catch (_) {
      return const Left(Failure(message: 'Failed to get address'));
    }
  }

  @override
  Future<Either<Failure, XFile>> getImageFromGallery() async {
    try {
      final result = await localDataSource.getImageFromGallery();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (_) {
      return const Left(Failure(message: 'Failed to select image'));
    }
  }

  @override
  Future<Either<Failure, NoOutput>> updateUserData(
    Map<String, String> newData,
  ) async {
    try {
      final userId = localDataSource.getCachedUserId();
      await remoteDataSource.updateUserData(userId, newData);
      return Right(NoOutput());
    } catch (_) {
      return const Left(Failure(message: 'Failed to update info'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addVoucher(String code) async {
    try {
      final result = await remoteDataSource.checkVoucher(code);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (_) {
      return const Left(Failure(message: 'Failed to add voucher'));
    }
  }

  @override
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
  }) async {
    try {
      final userId = localDataSource.getCachedUserId();

      await remoteDataSource.makeOrder(
        userId: userId,
        governorate: governorate,
        city: city,
        street: street,
        postalCode: postalCode,
        products: products,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        voucher: voucher,
        shippingFees: shippingFees,
      );

      return Right(NoOutput());
    } catch (_) {
      return const Left(Failure(message: 'Failed to submit order'));
    }
  }

  @override
  Future<Either<Failure, List<OrderData>>> getUserOrders() async {
    try {
      final userId = localDataSource.getCachedUserId();
      final result = await remoteDataSource.getUserOrders(userId);
      return Right(result);
    } catch (_) {
      return const Left(Failure(message: 'Failed to get orders'));
    }
  }
}
