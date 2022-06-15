import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../error/failure.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/voucher_model.dart';

abstract class RemoteDataSource {
  Future<void> register(String email, String password);

  Future<String> login(String email, String password);

  Future<UserDataModel> getUserData(String userId);

  Future<List<ProductModel>> getPopularProducts();

  Future<void> updateFavorites(
    String userId,
    List<ProductModel> favorites,
  );

  Future<void> updateCartProducts(
    String userId,
    List<Map<String, dynamic>> cartProducts,
  );

  Future<List<CategoryModel>> getCategories();

  Future<void> changeCartProductCount(
    String userId,
    List<Map<String, dynamic>> cartProducts,
  );

  Future<Position> getUserLocation();

  Future<Placemark> getUserAddress(double longitude, double latitude);

  Future<String?> updateUserData(String userId, Map<String, String> newData);

  Future<Map<String, dynamic>> checkVoucher(String code);

  Future<void> makeOrder({
    required String userId,
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

  Future<List<OrderModel>> getUserOrders(String userId);

  Future<List<ProductModel>> productSearch(String search);

  Future<List<ProductModel>> getCategoryProducts(String name);

  Future<void> downloadProductImage(String url, String name);

  Future<void> logout();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl(this.dio);

  @override
  Future<void> register(String email, String password) async {
    late UserCredential response;
    late UserDataModel user;

    response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    user = UserDataModel(
      id: response.user!.uid,
      email: response.user!.email!,
      memberSince: response.user!.metadata.creationTime.toString(),
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/e-commerce-dfc20.appspot.com/o/images%2Fusers%2Fdefault_user_image.jpg?alt=media&token=503f5a40-8633-4747-9f4f-16ad07174451',
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(response.user!.uid)
        .set(
          user.toJson(),
        );
  }

  @override
  Future<String> login(String email, String password) async {
    final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return response.user!.uid;
  }

  @override
  Future<UserDataModel> getUserData(String userId) async {
    final data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final UserDataModel user =
        UserDataModel.fromJson(data.data() as Map<String, dynamic>);
    return user;
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    final List<ProductModel> products = [];

    final productsResponse =
        await FirebaseFirestore.instance.collection('products').limit(6).get();

    for (var data in productsResponse.docs) {
      products.add(ProductModel.fromJson(data.data()));
    }

    return products;
  }

  @override
  Future<void> updateFavorites(
    String userId,
    List<ProductModel> favorites,
  ) async {
    final newFavorites = favorites.map((product) => product.toJson()).toList();

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favorites': newFavorites,
    });
  }

  @override
  Future<void> updateCartProducts(
    String userId,
    List<Map<String, dynamic>> cartProducts,
  ) async {
    final newCartProducts = cartProducts.map((productMap) {
      final product = (productMap['product'] as ProductModel).toJson();
      final count = productMap['count'];
      return {
        'product': product,
        'count': count,
      };
    }).toList();

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'cartProducts': newCartProducts,
    });
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final List<CategoryModel> categories = [];

    final result =
        await FirebaseFirestore.instance.collection('categories').get();
    for (var catData in result.docs) {
      categories.add(CategoryModel.fromJson(catData.data()));
    }
    return categories;
  }

  @override
  Future<void> changeCartProductCount(
    String userId,
    List<Map<String, dynamic>> cartProducts,
  ) async {
    final newCartProducts = cartProducts.map((productMap) {
      final product = (productMap['product'] as ProductModel).toJson();
      final count = productMap['count'];
      return {
        'product': product,
        'count': count,
      };
    }).toList();

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'cartProducts': newCartProducts,
    });
  }

  @override
  Future<Position> getUserLocation() async {
    late Position position;

    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw const Failure(message: 'Location service is disabled');
    } else {
      try {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.unableToDetermine) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            throw const Failure(
              message: 'Location permission denied',
            );
          } else {
            position = await _getPosition();
            return position;
          }
        } else {
          position = await _getPosition();
          return position;
        }
      } on PermissionDefinitionsNotFoundException {
        throw const Failure(
          message: 'Permission definition not found',
        );
      } on PermissionRequestInProgressException {
        throw const Failure(
          message: 'Handling another permission, please wait',
        );
      } on TimeoutException {
        throw const Failure(
          message: 'Connection timeout',
        );
      } on LocationServiceDisabledException {
        throw const Failure(
          message: 'Location service is disabled',
        );
      }
    }
  }

  Future<Position> _getPosition() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(minutes: 1),
    );
    return position;
  }

  @override
  Future<Placemark> getUserAddress(double longitude, double latitude) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      longitude,
      latitude,
      localeIdentifier: 'en_EG',
    );

    return placeMarks.first;
  }

  @override
  Future<String?> updateUserData(
    String userId,
    Map<String, String> newData,
  ) async {
    if (newData.containsKey('imageUrl')) {
      final file = File(newData['imageUrl']!);
      final storageRef = FirebaseStorage.instance.ref();

      final mountainsRef = storageRef
          .child('images/users/$userId/${file.uri.pathSegments.last}');

      await mountainsRef.putFile(file);

      final newImageUrl = await mountainsRef.getDownloadURL();

      newData.update('imageUrl', (value) => newImageUrl);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(newData);

      return newImageUrl;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(newData);

    return null;
  }

  @override
  Future<Map<String, dynamic>> checkVoucher(String code) async {
    final result =
        await FirebaseFirestore.instance.collection('vouchers').get();

    if (result.docs.isNotEmpty) {
      for (var codeData in result.docs) {
        final voucher = VoucherModel.fromJson(codeData.data());
        if (voucher.code == code) {
          if (voucher.status == 'active') {
            return {
              'code': voucher.code,
              'value': voucher.value,
            };
          } else {
            throw const Failure(message: 'Code is expired');
          }
        }
      }
      throw const Failure(message: 'Invalid code');
    } else {
      throw const Failure(message: 'Invalid code');
    }
  }

  @override
  Future<void> makeOrder({
    required String userId,
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
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .add({});

    final order = OrderModel(
      id: doc.id,
      status: 'placed',
      userId: userId,
      placedDate: DateTime.now().toString(),
      totalPrice: totalPrice,
      governorate: governorate,
      city: city,
      street: street,
      postalCode: postalCode,
      products: products,
      paymentMethod: paymentMethod,
      voucher: voucher,
      shippingFees: shippingFees,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(doc.id)
        .set(order.toJson());

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'cartProducts': [],
    });
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    final List<OrderModel> orders = [];

    final ordersData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .get();

    for (var order in ordersData.docs) {
      orders.add(OrderModel.fromJson(order.data()));
    }

    return orders;
  }

  @override
  Future<List<ProductModel>> productSearch(String search) async {
    final List<ProductModel> products = [];
    final result =
        await FirebaseFirestore.instance.collection('products').get();

    for (var data in result.docs) {
      products.add(ProductModel.fromJson(data.data()));
    }

    products.removeWhere((product) {
      return !product.name.toLowerCase().contains(search.toLowerCase());
    });

    return products;
  }

  @override
  Future<List<ProductModel>> getCategoryProducts(String name) async {
    final List<ProductModel> products = [];
    final result =
        await FirebaseFirestore.instance.collection('products').get();

    for (var data in result.docs) {
      products.add(ProductModel.fromJson(data.data()));
    }

    products.removeWhere((product) {
      return product.category.name != name;
    });

    return products;
  }

  @override
  Future<void> downloadProductImage(String url, String name) async {
    var status = await Permission.storage.status;
    switch (status) {
      case PermissionStatus.denied:
        status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          await _downLoadImage(url, name);
          break;
        } else {
          throw const Failure(message: 'Permission denied');
        }
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        await _downLoadImage(url, name);
        break;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        throw const Failure(message: 'Permission denied forever');
    }
  }

  Future<void> _downLoadImage(String url, String name) async {
    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 80,
      name: name,
    );

    if (result['isSuccess'] == false) {
      throw const Failure(message: 'Could not download image');
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
