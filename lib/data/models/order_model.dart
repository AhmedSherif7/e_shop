import '../../domain/entities/order.dart';
import '../mappers/mapper.dart';
import 'product_model.dart';

class OrderModel extends OrderData {
  const OrderModel({
    required String id,
    required String status,
    required String userId,
    required String placedDate,
    String shippedDate = emptyString,
    String deliveredDate = emptyString,
    required double totalPrice,
    required String governorate,
    required String city,
    required String street,
    required String postalCode,
    required List<Map<String, dynamic>> products,
    required String paymentMethod,
    required double voucher,
    required double shippingFees,
  }) : super(
          id: id,
          status: status,
          userId: userId,
          placedDate: placedDate,
          shippedDate: shippedDate,
          deliveredDate: deliveredDate,
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

  factory OrderModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      final List<Map<String, dynamic>> products = [];
      if (json['products'] != null) {
        final productsJson = json['products'];
        for (var productMap in productsJson) {
          products.add({
            'product': ProductModel.fromJson(productMap['product']),
            'count': productMap['count'],
          });
        }
      }

      return OrderModel(
        id: (json['id'] as String?).orEmpty(),
        status: (json['status'] as String?).orEmpty(),
        userId: (json['userId'] as String?).orEmpty(),
        placedDate: (json['placedDate'] as String?).orEmpty(),
        shippedDate: (json['shippedDate'] as String?).orEmpty(),
        deliveredDate: (json['deliveredDate'] as String?).orEmpty(),
        totalPrice: ((json['totalPrice'] as num?)?.toDouble()).orEmpty(),
        governorate: (json['governorate'] as String?).orEmpty(),
        city: (json['city'] as String?).orEmpty(),
        street: (json['street'] as String?).orEmpty(),
        postalCode: (json['postalCode'] as String?).orEmpty(),
        products: products,
        paymentMethod: (json['paymentMethod'] as String?).orEmpty(),
        voucher: ((json['voucher'] as num?)?.toDouble()).orEmpty(),
        shippingFees: ((json['shippingFees'] as num?)?.toDouble()).orEmpty(),
      );
    }
    return const OrderModel(
      id: emptyString,
      status: emptyString,
      userId: emptyString,
      placedDate: emptyString,
      shippedDate: emptyString,
      deliveredDate: emptyString,
      totalPrice: zeroDouble,
      governorate: emptyString,
      city: emptyString,
      street: emptyString,
      postalCode: emptyString,
      products: [],
      paymentMethod: emptyString,
      voucher: zeroDouble,
      shippingFees: zeroDouble,
    );
  }

  Map<String, dynamic> toJson() {
    final products = this.products.map((productMap) {
      return {
        'count': productMap['count'],
        'product': (productMap['product'] as ProductModel).toJson(),
      };
    }).toList();

    return {
      'id': id,
      'status': status,
      'userId': userId,
      'placedDate': placedDate,
      'shippedDate': shippedDate,
      'deliveredDate': deliveredDate,
      'totalPrice': totalPrice,
      'governorate': governorate,
      'city': city,
      'street': street,
      'postalCode': postalCode,
      'products': products,
      'paymentMethod': paymentMethod,
      'voucher': voucher,
      'shippingFees': shippingFees,
    };
  }
}
