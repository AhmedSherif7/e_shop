import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/functions.dart';
import '../../blocs/search/search_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../resources/colors_manager.dart';
import '../custom_button.dart';
import '../filter_option.dart';

class SearchBottomSheet extends StatelessWidget {
  const SearchBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Container(
            color: state.isDarkMode ? ColorManager.black : ColorManager.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: 25.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: ColorManager.grey,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
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
                    title: 'Price',
                    options:
                        BlocSelector<SearchCubit, SearchState, PriceFilter>(
                      selector: (state) {
                        return state.priceFilter;
                      },
                      builder: (context, priceFilter) {
                        return Wrap(
                          children: [
                            RangeSlider(
                              values: RangeValues(
                                  priceFilter.start, priceFilter.end),
                              activeColor: ColorManager.secondary,
                              divisions: 10,
                              min: 0,
                              max: 4000,
                              labels: RangeLabels(
                                'EGP ${priceFilter.start}',
                                'EGP ${priceFilter.end}',
                              ),
                              onChanged: (val) {
                                context
                                    .read<SearchCubit>()
                                    .changePriceFilter(val.start, val.end);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    clearFunction: () {
                      context.read<SearchCubit>().changePriceFilter(0, 0);
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FilterOption(
                    title: 'Category',
                    options:
                        BlocSelector<SearchCubit, SearchState, CategoryFilter>(
                      selector: (state) {
                        return state.categoryFilter;
                      },
                      builder: (context, orderStatusFilter) {
                        return Wrap(
                          children: [
                            FilterChip(
                              labelStyle: TextStyle(
                                color: orderStatusFilter == CategoryFilter.home
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor:
                                  orderStatusFilter == CategoryFilter.home
                                      ? ColorManager.white
                                      : ColorManager.black,
                              label: const Text('Home & Kitchen'),
                              onSelected: (value) {
                                context
                                    .read<SearchCubit>()
                                    .changeCategoryFilter(
                                      'home',
                                    );
                              },
                              selected:
                                  orderStatusFilter == CategoryFilter.home,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color:
                                    orderStatusFilter == CategoryFilter.beauty
                                        ? ColorManager.white
                                        : ColorManager.black,
                              ),
                              checkmarkColor:
                                  orderStatusFilter == CategoryFilter.beauty
                                      ? ColorManager.white
                                      : ColorManager.black,
                              label: const Text('Beauty & Personal Care'),
                              onSelected: (value) {
                                context
                                    .read<SearchCubit>()
                                    .changeCategoryFilter(
                                      'beauty',
                                    );
                              },
                              selected:
                                  orderStatusFilter == CategoryFilter.beauty,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color: orderStatusFilter ==
                                        CategoryFilter.electronics
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor: orderStatusFilter ==
                                      CategoryFilter.electronics
                                  ? ColorManager.white
                                  : ColorManager.black,
                              label: const Text('Electronics'),
                              onSelected: (value) {
                                context
                                    .read<SearchCubit>()
                                    .changeCategoryFilter(
                                      'electronics',
                                    );
                              },
                              selected: orderStatusFilter ==
                                  CategoryFilter.electronics,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color:
                                    orderStatusFilter == CategoryFilter.phones
                                        ? ColorManager.white
                                        : ColorManager.black,
                              ),
                              checkmarkColor:
                                  orderStatusFilter == CategoryFilter.phones
                                      ? ColorManager.white
                                      : ColorManager.black,
                              label: const Text('Phones & Tablets'),
                              onSelected: (value) {
                                context
                                    .read<SearchCubit>()
                                    .changeCategoryFilter(
                                      'phones',
                                    );
                              },
                              selected:
                                  orderStatusFilter == CategoryFilter.phones,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color:
                                    orderStatusFilter == CategoryFilter.sports
                                        ? ColorManager.white
                                        : ColorManager.black,
                              ),
                              checkmarkColor:
                                  orderStatusFilter == CategoryFilter.sports
                                      ? ColorManager.white
                                      : ColorManager.black,
                              label: const Text('Sports & Outdoors'),
                              onSelected: (value) {
                                context
                                    .read<SearchCubit>()
                                    .changeCategoryFilter(
                                      'sports',
                                    );
                              },
                              selected:
                                  orderStatusFilter == CategoryFilter.sports,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color: orderStatusFilter ==
                                        CategoryFilter.computers
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor:
                                  orderStatusFilter == CategoryFilter.computers
                                      ? ColorManager.white
                                      : ColorManager.black,
                              label: const Text('Computers'),
                              onSelected: (value) {
                                context
                                    .read<SearchCubit>()
                                    .changeCategoryFilter(
                                      'computers',
                                    );
                              },
                              selected:
                                  orderStatusFilter == CategoryFilter.computers,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color: orderStatusFilter == CategoryFilter.games
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor: orderStatusFilter ==
                                      CategoryFilter.electronics
                                  ? ColorManager.white
                                  : ColorManager.black,
                              label: const Text('Video Games'),
                              onSelected: (value) {
                                context
                                    .read<SearchCubit>()
                                    .changeCategoryFilter(
                                      'games',
                                    );
                              },
                              selected:
                                  orderStatusFilter == CategoryFilter.games,
                              selectedColor: ColorManager.secondary,
                            ),
                          ],
                        );
                      },
                    ),
                    clearFunction: () {
                      context.read<SearchCubit>().changeCategoryFilter('none');
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FilterOption(
                    title: 'Min Rate',
                    options: BlocSelector<SearchCubit, SearchState, RateFilter>(
                      selector: (state) {
                        return state.rateFilter;
                      },
                      builder: (context, rateFilter) {
                        return Wrap(
                          children: [
                            FilterChip(
                              labelStyle: TextStyle(
                                color: rateFilter == RateFilter.one
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor: rateFilter == RateFilter.one
                                  ? ColorManager.white
                                  : ColorManager.black,
                              label: const Text('1'),
                              onSelected: (value) {
                                context.read<SearchCubit>().changeRateFilter(
                                      '1',
                                    );
                              },
                              selected: rateFilter == RateFilter.one,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color: rateFilter == RateFilter.two
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor: rateFilter == RateFilter.two
                                  ? ColorManager.white
                                  : ColorManager.black,
                              label: const Text('2'),
                              onSelected: (value) {
                                context.read<SearchCubit>().changeRateFilter(
                                      '2',
                                    );
                              },
                              selected: rateFilter == RateFilter.two,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color: rateFilter == RateFilter.three
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor: rateFilter == RateFilter.three
                                  ? ColorManager.white
                                  : ColorManager.black,
                              label: const Text('3'),
                              onSelected: (value) {
                                context.read<SearchCubit>().changeRateFilter(
                                      '3',
                                    );
                              },
                              selected: rateFilter == RateFilter.three,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color: rateFilter == RateFilter.four
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor: rateFilter == RateFilter.four
                                  ? ColorManager.white
                                  : ColorManager.black,
                              label: const Text('4'),
                              onSelected: (value) {
                                context.read<SearchCubit>().changeRateFilter(
                                      '4',
                                    );
                              },
                              selected: rateFilter == RateFilter.four,
                              selectedColor: ColorManager.secondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              labelStyle: TextStyle(
                                color: rateFilter == RateFilter.five
                                    ? ColorManager.white
                                    : ColorManager.black,
                              ),
                              checkmarkColor: rateFilter == RateFilter.five
                                  ? ColorManager.white
                                  : ColorManager.black,
                              label: const Text('5'),
                              onSelected: (value) {
                                context.read<SearchCubit>().changeRateFilter(
                                      '5',
                                    );
                              },
                              selected: rateFilter == RateFilter.five,
                              selectedColor: ColorManager.secondary,
                            ),
                          ],
                        );
                      },
                    ),
                    clearFunction: () {
                      context.read<SearchCubit>().changeRateFilter('none');
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              context.read<SearchCubit>().saveFilters();
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
                              context.read<SearchCubit>().resetFilters();
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
            ),
          );
        },
      ),
    );
  }
}
