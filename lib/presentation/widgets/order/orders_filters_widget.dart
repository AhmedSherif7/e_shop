import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/orders/orders_cubit.dart';
import '../../resources/colors_manager.dart';
import 'orders_bottom_sheet.dart';

class OrdersFiltersWidget extends StatelessWidget {
  const OrdersFiltersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return BlocProvider<OrdersCubit>.value(
              value: context.read<OrdersCubit>(),
              child: const OrderBottomSheet(),
            );
          },
        );
      },
      icon: Stack(
        children: [
          const Icon(
            Ionicons.filter,
            size: 28.0,
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: BlocSelector<OrdersCubit, OrdersState, int>(
              selector: (state) {
                return state.appliedFilters.length;
              },
              builder: (context, count) {
                if (count > 0) {
                  return Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: ColorManager.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: ColorManager.white,
                        fontSize: 11.0,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
