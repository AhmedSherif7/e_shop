import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../app/di.dart';
import '../blocs/orders/orders_cubit.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/order/empty_orders_screen_body.dart';
import '../widgets/order/order_item.dart';
import '../widgets/order/orders_filters_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrdersCubit>()..getOrders(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Ionicons.chevron_back),
          ),
          title: const Text('My Orders'),
          actions: [
            Builder(
              builder: (context) {
                return const OrdersFiltersWidget();
              },
            ),
          ],
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          buildWhen: (previous, current) {
            return previous.orderPageStatus != current.orderPageStatus ||
                previous.filteredOrders != current.filteredOrders;
          },
          builder: (context, state) {
            switch (state.orderPageStatus) {
              case OrderPageStatus.loading:
                return const Center(
                  child: LoadingWidget(),
                );
              case OrderPageStatus.success:
                return ConditionalBuilder(
                  condition: state.filteredOrders.isEmpty,
                  builder: (context) {
                    return const EmptyOrderScreenBody();
                  },
                  fallback: (context) {
                    return ListView.separated(
                      itemCount: state.filteredOrders.length,
                      itemBuilder: (context, index) {
                        return OrderItem(
                          state.filteredOrders[index],
                          index,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 20.0,
                        );
                      },
                    );
                  },
                );
              case OrderPageStatus.error:
                return Center(
                  child: FailureWidget(
                    error: state.errorMessage!,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
