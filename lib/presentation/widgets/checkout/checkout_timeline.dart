import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../blocs/checkout/checkout_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';

class CheckoutTimeline extends StatelessWidget {
  const CheckoutTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CheckoutCubit, CheckoutState, CheckoutStep>(
      selector: (state) {
        return state.checkoutStep;
      },
      builder: (context, checkoutStep) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return SizedBox(
              height: 120.0,
              child: Row(
                children: [
                  Expanded(
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      axis: TimelineAxis.horizontal,
                      isFirst: true,
                      startChild: Icon(
                        Ionicons.location_outline,
                        size: 28.0,
                        color: checkoutStep == CheckoutStep.delivery
                            ? ColorManager.primary
                            : ColorManager.green,
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Text(
                            'Delivery',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: checkoutStep == CheckoutStep.delivery
                                  ? ColorManager.primary
                                  : ColorManager.green,
                            ),
                          ),
                        ),
                      ),
                      indicatorStyle: IndicatorStyle(
                        height: 22.0,
                        width: 22.0,
                        drawGap: true,
                        indicator: CircleAvatar(
                          backgroundColor: checkoutStep == CheckoutStep.delivery
                              ? ColorManager.primary
                              : ColorManager.green,
                          child: checkoutStep != CheckoutStep.delivery
                              ? const Icon(
                                  Ionicons.checkmark_outline,
                                  color: ColorManager.white,
                                  size: 22.0,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                      afterLineStyle: LineStyle(
                        color: checkoutStep != CheckoutStep.delivery
                            ? ColorManager.green
                            : ColorManager.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      axis: TimelineAxis.horizontal,
                      startChild: Icon(
                        Ionicons.wallet,
                        size: 28.0,
                        color: checkoutStep == CheckoutStep.payment
                            ? ColorManager.primary
                            : checkoutStep == CheckoutStep.delivery
                                ? ColorManager.grey
                                : ColorManager.green,
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Text(
                            'Payment',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: checkoutStep == CheckoutStep.payment
                                  ? ColorManager.primary
                                  : checkoutStep == CheckoutStep.delivery
                                      ? ColorManager.grey
                                      : ColorManager.green,
                            ),
                          ),
                        ),
                      ),
                      indicatorStyle: IndicatorStyle(
                        height: 22.0,
                        width: 22.0,
                        indicator: CircleAvatar(
                          backgroundColor: checkoutStep == CheckoutStep.payment
                              ? ColorManager.primary
                              : checkoutStep == CheckoutStep.delivery
                                  ? ColorManager.grey
                                  : ColorManager.green,
                          child: checkoutStep == CheckoutStep.summary
                              ? const Icon(
                                  Ionicons.checkmark_outline,
                                  color: ColorManager.white,
                                  size: 22.0,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                        color: checkoutStep == CheckoutStep.delivery
                            ? ColorManager.grey
                            : ColorManager.green,
                      ),
                      afterLineStyle: LineStyle(
                        color: checkoutStep == CheckoutStep.summary
                            ? ColorManager.green
                            : ColorManager.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      axis: TimelineAxis.horizontal,
                      isLast: true,
                      startChild: Icon(
                        Ionicons.book,
                        size: 28.0,
                        color: checkoutStep == CheckoutStep.summary
                            ? ColorManager.primary
                            : ColorManager.grey,
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: checkoutStep == CheckoutStep.summary
                                  ? ColorManager.primary
                                  : ColorManager.grey,
                            ),
                          ),
                        ),
                      ),
                      indicatorStyle: IndicatorStyle(
                        height: 22.0,
                        width: 22.0,
                        indicator: CircleAvatar(
                          backgroundColor: checkoutStep == CheckoutStep.summary
                              ? ColorManager.primary
                              : ColorManager.grey,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                        color: checkoutStep == CheckoutStep.summary
                            ? ColorManager.green
                            : ColorManager.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
