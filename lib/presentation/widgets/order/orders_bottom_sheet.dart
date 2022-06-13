import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/functions.dart';
import '../../blocs/orders/orders_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import '../custom_bottom_sheet.dart';
import '../custom_button.dart';
import '../filter_option.dart';

class OrderBottomSheet extends StatelessWidget {
  const OrderBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return CustomBottomSheet(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Filters',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: state.isDarkMode
                      ? ColorManager.white
                      : ColorManager.black,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FilterOption(
                title: 'Payment Method',
                options:
                    BlocSelector<OrdersCubit, OrdersState, PaymentMethodFilter>(
                  selector: (state) {
                    return state.paymentMethodFilter;
                  },
                  builder: (context, paymentMethodFilter) {
                    return Row(
                      children: [
                        FilterChip(
                          labelStyle: TextStyle(
                            color:
                                paymentMethodFilter == PaymentMethodFilter.card
                                    ? ColorManager.white
                                    : ColorManager.black,
                          ),
                          checkmarkColor:
                              paymentMethodFilter == PaymentMethodFilter.card
                                  ? ColorManager.white
                                  : ColorManager.black,
                          label: const Text('Card'),
                          onSelected: (value) {
                            context
                                .read<OrdersCubit>()
                                .changePaymentMethodFilter(
                                  'card',
                                );
                          },
                          selected:
                              paymentMethodFilter == PaymentMethodFilter.card,
                          selectedColor: ColorManager.secondary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FilterChip(
                          labelStyle: TextStyle(
                            color:
                                paymentMethodFilter == PaymentMethodFilter.cash
                                    ? ColorManager.white
                                    : ColorManager.black,
                          ),
                          checkmarkColor:
                              paymentMethodFilter == PaymentMethodFilter.cash
                                  ? ColorManager.white
                                  : ColorManager.black,
                          label: const Text('Cash'),
                          onSelected: (value) {
                            context
                                .read<OrdersCubit>()
                                .changePaymentMethodFilter(
                                  'cash',
                                );
                          },
                          selected:
                              paymentMethodFilter == PaymentMethodFilter.cash,
                          selectedColor: ColorManager.secondary,
                        ),
                      ],
                    );
                  },
                ),
                clearFunction: () {
                  context.read<OrdersCubit>().changePaymentMethodFilter(
                        'none',
                      );
                },
              ),
              FilterOption(
                title: 'Order Status',
                options:
                    BlocSelector<OrdersCubit, OrdersState, OrderStatusFilter>(
                  selector: (state) {
                    return state.orderStatusFilter;
                  },
                  builder: (context, orderStatusFilter) {
                    return Row(
                      children: [
                        FilterChip(
                          labelStyle: TextStyle(
                            color: orderStatusFilter == OrderStatusFilter.placed
                                ? ColorManager.white
                                : ColorManager.black,
                          ),
                          checkmarkColor:
                              orderStatusFilter == OrderStatusFilter.placed
                                  ? ColorManager.white
                                  : ColorManager.black,
                          label: const Text('Placed'),
                          onSelected: (value) {
                            context.read<OrdersCubit>().changeOrderStatusFilter(
                                  'placed',
                                );
                          },
                          selected:
                              orderStatusFilter == OrderStatusFilter.placed,
                          selectedColor: ColorManager.secondary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FilterChip(
                          labelStyle: TextStyle(
                            color:
                                orderStatusFilter == OrderStatusFilter.shipped
                                    ? ColorManager.white
                                    : ColorManager.black,
                          ),
                          checkmarkColor:
                              orderStatusFilter == OrderStatusFilter.shipped
                                  ? ColorManager.white
                                  : ColorManager.black,
                          label: const Text('Shipped'),
                          onSelected: (value) {
                            context.read<OrdersCubit>().changeOrderStatusFilter(
                                  'shipped',
                                );
                          },
                          selected:
                              orderStatusFilter == OrderStatusFilter.shipped,
                          selectedColor: ColorManager.secondary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        FilterChip(
                          labelStyle: TextStyle(
                            color:
                                orderStatusFilter == OrderStatusFilter.delivered
                                    ? ColorManager.white
                                    : ColorManager.black,
                          ),
                          checkmarkColor:
                              orderStatusFilter == OrderStatusFilter.delivered
                                  ? ColorManager.white
                                  : ColorManager.black,
                          label: const Text('Delivered'),
                          onSelected: (value) {
                            context.read<OrdersCubit>().changeOrderStatusFilter(
                                  'delivered',
                                );
                          },
                          selected:
                              orderStatusFilter == OrderStatusFilter.delivered,
                          selectedColor: ColorManager.secondary,
                        ),
                      ],
                    );
                  },
                ),
                clearFunction: () {
                  context.read<OrdersCubit>().changeOrderStatusFilter(
                        'none',
                      );
                },
              ),
              const Spacer(),
              SizedBox(
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          context.read<OrdersCubit>().saveFilters();
                          Navigator.pop(context);
                          toggleSnackBar(
                            context: context,
                            message: 'Filters applied',
                            success: true,
                          );
                        },
                        title: 'SAVE',
                        color: ColorManager.indigo,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          context.read<OrdersCubit>().resetFilters();
                        },
                        title: 'RESET',
                        color: ColorManager.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
