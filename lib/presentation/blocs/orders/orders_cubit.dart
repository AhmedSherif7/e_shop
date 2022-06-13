import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/order.dart';
import '../../../domain/use_cases/base_use_case.dart';
import '../../../domain/use_cases/get_user_orders_use_case.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetUserOrdersUseCase getUserOrdersUseCase;

  OrdersCubit(
    this.getUserOrdersUseCase,
  ) : super(const OrdersState());

  void getOrders() async {
    emit(
      state.copyWith(
        orderPageStatus: OrderPageStatus.loading,
      ),
    );

    final result = await getUserOrdersUseCase(NoParams());
    result.fold(
      (error) {
        emit(
          state.copyWith(
            orderPageStatus: OrderPageStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (orders) {
        emit(
          state.copyWith(
            orderPageStatus: OrderPageStatus.success,
            orders: orders,
            filteredOrders: orders,
          ),
        );
      },
    );
  }

  void changePaymentMethodFilter(String filter) {
    if (filter == 'card') {
      emit(
        state.copyWith(
          paymentMethodFilter: PaymentMethodFilter.card,
        ),
      );
    } else if (filter == 'cash') {
      emit(
        state.copyWith(
          paymentMethodFilter: PaymentMethodFilter.cash,
        ),
      );
    } else {
      emit(
        state.copyWith(
          paymentMethodFilter: PaymentMethodFilter.none,
        ),
      );
    }
  }

  void changeOrderStatusFilter(String filter) {
    if (filter == 'placed') {
      emit(
        state.copyWith(
          orderStatusFilter: OrderStatusFilter.placed,
        ),
      );
    } else if (filter == 'shipped') {
      emit(
        state.copyWith(
          orderStatusFilter: OrderStatusFilter.shipped,
        ),
      );
    } else if (filter == 'delivered') {
      emit(
        state.copyWith(
          orderStatusFilter: OrderStatusFilter.delivered,
        ),
      );
    } else {
      emit(
        state.copyWith(
          orderStatusFilter: OrderStatusFilter.none,
        ),
      );
    }
  }

  void saveFilters() {
    final List<String> newAppliedFilters = List.from(state.appliedFilters);

    if (state.paymentMethodFilter == PaymentMethodFilter.none &&
        state.orderStatusFilter == OrderStatusFilter.none) {
      emit(
        state.copyWith(
          filteredOrders: state.orders,
          appliedFilters: const [],
        ),
      );
      return;
    }

    final List<OrderData> newOrders = List.from(state.orders);
    if (state.paymentMethodFilter != PaymentMethodFilter.none) {

      if (!newAppliedFilters.contains('paymentFilter')) {
        newAppliedFilters.add('paymentFilter');
      }

      if (state.paymentMethodFilter == PaymentMethodFilter.card) {
        newOrders.removeWhere((order) => order.paymentMethod != 'Pay by Card');
      } else {
        newOrders
            .removeWhere((order) => order.paymentMethod != 'Cash on Delivery');
      }
    } else {
      newAppliedFilters.remove('paymentFilter');
    }

    if (state.orderStatusFilter != OrderStatusFilter.none) {
      if (!newAppliedFilters.contains('orderStatusFilter')) {
        newAppliedFilters.add('orderStatusFilter');
      }

      if (state.orderStatusFilter == OrderStatusFilter.placed) {
        newOrders.removeWhere((order) => order.status != 'placed');
      } else if (state.orderStatusFilter == OrderStatusFilter.shipped) {
        newOrders.removeWhere((order) => order.status != 'shipped');
      } else {
        newOrders.removeWhere((order) => order.status != 'delivered');
      }
    } else {
      newAppliedFilters.remove('orderStatusFilter');
    }

    emit(
      state.copyWith(
        filteredOrders: newOrders,
        appliedFilters: newAppliedFilters,
      ),
    );
  }

  void resetFilters() {
    emit(
      state.copyWith(
        paymentMethodFilter: PaymentMethodFilter.none,
        orderStatusFilter: OrderStatusFilter.none,
      ),
    );
  }
}
