import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timelines/timelines.dart';

import '../../../domain/entities/order.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';

class OrderItem extends StatelessWidget {
  const OrderItem(this.order, this.index, {Key? key}) : super(key: key);

  final OrderData order;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Text(
            '${index + 1}.',
            style: TextStyle(
              fontSize: 20.0,
              color: state.isDarkMode ? ColorManager.white : ColorManager.black,
            ),
          );
        },
      ),
      title: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Text(
            'Order # : ${order.id}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              fontFamily: FontFamilyManager.montserrat,
              color: state.isDarkMode ? ColorManager.white : ColorManager.black,
            ),
          );
        },
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price : EGP ${order.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              fontFamily: FontFamilyManager.nunitoSans,
              color: ColorManager.secondary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Payment : ${order.paymentMethod}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  fontFamily: FontFamilyManager.nunitoSans,
                  color: ColorManager.green,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Icon(
                order.paymentMethod == 'Pay by Card'
                    ? Ionicons.card
                    : Ionicons.hand_left,
                color: ColorManager.black38,
              ),
            ],
          ),
        ],
      ),
      children: [
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: order.products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Image(
                      image: NetworkImage(
                        order.products[index]['product'].images[0],
                      ),
                    ),
                  ),
                  title: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      return Text(
                        order.products[index]['product'].name,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: state.isDarkMode
                              ? ColorManager.white
                              : ColorManager.black,
                        ),
                      );
                    },
                  ),
                  subtitle: Text(
                    'EGP ${order.products[index]['product'].price}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: ColorManager.indigo,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      'x${order.products[index]['count'].toString()}',
                      style: const TextStyle(
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            Timeline.tileBuilder(
              shrinkWrap: true,
              primary: false,
              builder: TimelineTileBuilder.connected(
                contentsAlign: ContentsAlign.alternating,
                itemCount: 3,
                indicatorBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: ColorManager.timeLineDone,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Icon(
                          Ionicons.checkmark_outline,
                          size: 16.0,
                          color: ColorManager.white,
                        ),
                      );
                    case 1:
                      if (order.status == 'shipped' ||
                          order.status == 'delivered') {
                        return Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: ColorManager.timeLineDone,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Icon(
                            Ionicons.checkmark_outline,
                            size: 16.0,
                            color: ColorManager.white,
                          ),
                        );
                      } else {
                        return Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              width: 2.0,
                              color: ColorManager.lightGrey350,
                            ),
                          ),
                        );
                      }
                    case 2:
                      if (order.status == 'delivered') {
                        return Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: ColorManager.timeLineDone,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Icon(
                            Ionicons.checkmark_outline,
                            size: 16.0,
                            color: ColorManager.white,
                          ),
                        );
                      } else {
                        return Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              width: 2.0,
                              color: ColorManager.lightGrey350,
                            ),
                          ),
                        );
                      }
                  }
                  return null;
                },
                connectorBuilder: (context, index, connectorType) {
                  late Color color;
                  if (order.status == 'placed') {
                    color = ColorManager.lightGrey350;
                  } else if (order.status == 'shipped' && index == 0) {
                    color = ColorManager.timeLineDone;
                  } else if (order.status == 'shipped' && index == 1) {
                    color = ColorManager.lightGrey350;
                  } else if (order.status == 'delivered') {
                    color = ColorManager.timeLineDone;
                  }
                  return Container(
                    width: 2.0,
                    color: color,
                  );
                },
                contentsBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 12.0,
                        ),
                        child: Text(
                          'Placed at: ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(order.placedDate))}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: FontFamilyManager.montserrat,
                            color: ColorManager.indigo,
                          ),
                        ),
                      );
                    case 1:
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 12.0,
                        ),
                        child: Text(
                          order.status != 'placed'
                              ? 'Shipped at: ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(order.shippedDate))}'
                              : 'Not shipped yet',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: FontFamilyManager.montserrat,
                            color: order.status != 'placed'
                                ? ColorManager.indigo
                                : ColorManager.black38,
                          ),
                        ),
                      );
                    case 2:
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 12.0,
                        ),
                        child: Text(
                          order.status == 'delivered'
                              ? 'Delivered at: ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(order.deliveredDate))}'
                              : 'Not delivered yet',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: FontFamilyManager.montserrat,
                            color: order.status == 'delivered'
                                ? ColorManager.indigo
                                : ColorManager.black38,
                          ),
                        ),
                      );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ],
    );
  }
}
