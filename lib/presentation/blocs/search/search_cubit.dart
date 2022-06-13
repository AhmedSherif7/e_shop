import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/use_cases/product_search_use_case.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ProductSearchUseCase productSearchUseCase;

  SearchCubit(this.productSearchUseCase) : super(const SearchState());

  void searchChanged(String value) {
    emit(
      state.copyWith(
        search: value,
      ),
    );
  }

  void search() async {
    emit(
      state.copyWith(
        searchPageStatus: SearchPageStatus.loading,
      ),
    );

    final result = await productSearchUseCase(state.search);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            searchPageStatus: SearchPageStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (products) {
        if (state.appliedFilters.isEmpty) {
          emit(
            state.copyWith(
              searchPageStatus: SearchPageStatus.success,
              products: products,
              filteredProducts: products,
            ),
          );
        } else {
          emit(
            state.copyWith(
              searchPageStatus: SearchPageStatus.success,
              products: products,
            ),
          );
          saveFilters();
        }
      },
    );
  }

  void changePriceFilter(double start, double end) {
    emit(
      state.copyWith(
        priceFilter: PriceFilter(start, end),
      ),
    );
  }

  void changeCategoryFilter(String filter) {
    if (filter == 'home') {
      emit(
        state.copyWith(
          categoryFilter: CategoryFilter.home,
        ),
      );
    } else if (filter == 'beauty') {
      emit(
        state.copyWith(
          categoryFilter: CategoryFilter.beauty,
        ),
      );
    } else if (filter == 'electronics') {
      emit(
        state.copyWith(
          categoryFilter: CategoryFilter.electronics,
        ),
      );
    } else if (filter == 'phones') {
      emit(
        state.copyWith(
          categoryFilter: CategoryFilter.phones,
        ),
      );
    } else if (filter == 'sports') {
      emit(
        state.copyWith(
          categoryFilter: CategoryFilter.sports,
        ),
      );
    } else if (filter == 'computers') {
      emit(
        state.copyWith(
          categoryFilter: CategoryFilter.computers,
        ),
      );
    } else if (filter == 'games') {
      emit(
        state.copyWith(
          categoryFilter: CategoryFilter.games,
        ),
      );
    } else {
      emit(
        state.copyWith(
          categoryFilter: CategoryFilter.none,
        ),
      );
    }
  }

  void changeRateFilter(String filter) {
    if (filter == '1') {
      emit(
        state.copyWith(
          rateFilter: RateFilter.one,
        ),
      );
    } else if (filter == '2') {
      emit(
        state.copyWith(
          rateFilter: RateFilter.two,
        ),
      );
    } else if (filter == '3') {
      emit(
        state.copyWith(
          rateFilter: RateFilter.three,
        ),
      );
    } else if (filter == '4') {
      emit(
        state.copyWith(
          rateFilter: RateFilter.four,
        ),
      );
    } else if (filter == '5') {
      emit(
        state.copyWith(
          rateFilter: RateFilter.five,
        ),
      );
    } else {
      emit(
        state.copyWith(
          rateFilter: RateFilter.none,
        ),
      );
    }
  }

  void saveFilters() {
    final List<String> newAppliedFilters = List.from(state.appliedFilters);

    if (state.priceFilter == const PriceFilter(0, 0) &&
        state.categoryFilter == CategoryFilter.none &&
        state.rateFilter == RateFilter.none) {
      emit(
        state.copyWith(
          filteredProducts: state.products,
          appliedFilters: const [],
        ),
      );
      return;
    }

    final List<Product> newProducts = List.from(state.products);
    if (state.priceFilter != const PriceFilter(0, 0)) {
      if (!newAppliedFilters.contains('priceFilter')) {
        newAppliedFilters.add('priceFilter');
      }

      newProducts.removeWhere(
        (product) =>
            product.price < state.priceFilter.start ||
            product.price > state.priceFilter.end,
      );
    } else {
      newAppliedFilters.remove('priceFilter');
    }

    if (state.categoryFilter != CategoryFilter.none) {
      if (!newAppliedFilters.contains('categoryFilter')) {
        newAppliedFilters.add('categoryFilter');
      }

      if (state.categoryFilter == CategoryFilter.home) {
        newProducts.removeWhere(
            (product) => product.category.name != 'Home & Kitchen');
      } else if (state.categoryFilter == CategoryFilter.beauty) {
        newProducts.removeWhere(
            (product) => product.category.name != 'Beauty & Personal Care');
      } else if (state.categoryFilter == CategoryFilter.electronics) {
        newProducts
            .removeWhere((product) => product.category.name != 'Electronics');
      } else if (state.categoryFilter == CategoryFilter.phones) {
        newProducts.removeWhere(
            (product) => product.category.name != 'Phones & Tablets');
      } else if (state.categoryFilter == CategoryFilter.sports) {
        newProducts.removeWhere(
            (product) => product.category.name != 'Sports & Outdoors');
      } else if (state.categoryFilter == CategoryFilter.computers) {
        newProducts
            .removeWhere((product) => product.category.name != 'Computers');
      } else {
        newProducts
            .removeWhere((product) => product.category.name != 'Video Games');
      }
    } else {
      newAppliedFilters.remove('categoryFilter');
    }

    if (state.rateFilter != RateFilter.none) {
      if (!newAppliedFilters.contains('rateFilter')) {
        newAppliedFilters.add('rateFilter');
      }

      if (state.rateFilter == RateFilter.one) {
        newProducts.removeWhere((product) => product.rate < 1);
      } else if (state.rateFilter == RateFilter.two) {
        newProducts.removeWhere((product) => product.rate < 2);
      } else if (state.rateFilter == RateFilter.three) {
        newProducts.removeWhere((product) => product.rate < 3);
      } else if (state.rateFilter == RateFilter.four) {
        newProducts.removeWhere((product) => product.rate < 4);
      } else {
        newProducts.removeWhere((product) => product.rate < 5);
      }
    } else {
      newAppliedFilters.remove('rateFilter');
    }

    emit(
      state.copyWith(
        filteredProducts: newProducts,
        appliedFilters: newAppliedFilters,
      ),
    );
  }

  void resetFilters() {
    emit(
      state.copyWith(
        priceFilter: const PriceFilter(0, 0),
        categoryFilter: CategoryFilter.none,
        rateFilter: RateFilter.none,
      ),
    );
  }

  void clearResults() {
    emit(
      const SearchState().copyWith(
        searchPageStatus: SearchPageStatus.clear,
      ),
    );
  }
}
