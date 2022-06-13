import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/search/search_cubit.dart';
import '../../resources/colors_manager.dart';
import 'search_bottom_sheet.dart';

class SearchFiltersWidget extends StatelessWidget {
  const SearchFiltersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return BlocProvider<SearchCubit>.value(
              value: context.read<SearchCubit>(),
              child: const SearchBottomSheet(),
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
            child: BlocSelector<SearchCubit, SearchState, int>(
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
