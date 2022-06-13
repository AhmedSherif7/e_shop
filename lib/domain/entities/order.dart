class OrderData {
  final String id;
  final String status;
  final String userId;
  final String placedDate;
  final String shippedDate;
  final String deliveredDate;
  final double totalPrice;
  final String governorate;
  final String city;
  final String street;
  final String postalCode;
  final List<Map<String, dynamic>> products;
  final String paymentMethod;
  final double voucher;
  final double shippingFees;

  const OrderData({
    required this.id,
    required this.status,
    required this.userId,
    required this.placedDate,
    required this.shippedDate,
    required this.deliveredDate,
    required this.totalPrice,
    required this.governorate,
    required this.city,
    required this.street,
    required this.postalCode,
    required this.products,
    required this.paymentMethod,
    required this.voucher,
    required this.shippingFees,
  });
}
