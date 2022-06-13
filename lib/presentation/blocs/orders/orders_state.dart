part of 'orders_cubit.dart';

enum OrderPageStatus {
  loading,
  success,
  error,
}

enum PaymentMethodFilter {
  none,
  card,
  cash,
}

enum OrderStatusFilter {
  none,
  placed,
  shipped,
  delivered,
}

@immutable
class OrdersState extends Equatable {
  final List<OrderData> orders;
  final List<OrderData> filteredOrders;
  final OrderPageStatus orderPageStatus;
  final String? errorMessage;
  final PaymentMethodFilter paymentMethodFilter;
  final OrderStatusFilter orderStatusFilter;
  final List<String> appliedFilters;

  const OrdersState({
    this.orders = const [],
    this.filteredOrders = const [],
    this.orderPageStatus = OrderPageStatus.loading,
    this.errorMessage,
    this.paymentMethodFilter = PaymentMethodFilter.none,
    this.orderStatusFilter = OrderStatusFilter.none,
    this.appliedFilters = const [],
  });

  @override
  List<Object?> get props =>
      [
        orders,
        filteredOrders,
        orderPageStatus,
        paymentMethodFilter,
        orderStatusFilter,
        appliedFilters,
      ];

  OrdersState copyWith({
    List<OrderData>? orders,
    List<OrderData>? filteredOrders,
    OrderPageStatus? orderPageStatus,
    String? errorMessage,
    PaymentMethodFilter? paymentMethodFilter,
    OrderStatusFilter? orderStatusFilter,
    List<String>? appliedFilters,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      orderPageStatus: orderPageStatus ?? this.orderPageStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      paymentMethodFilter: paymentMethodFilter ?? this.paymentMethodFilter,
      orderStatusFilter: orderStatusFilter ?? this.orderStatusFilter,
      appliedFilters: appliedFilters ?? this.appliedFilters,
    );
  }
}
