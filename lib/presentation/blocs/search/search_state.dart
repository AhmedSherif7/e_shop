part of 'search_cubit.dart';

enum SearchPageStatus {
  initial,
  loading,
  success,
  error,
  clear,
}

enum CategoryFilter {
  none,
  home,
  beauty,
  electronics,
  phones,
  sports,
  computers,
  games,
}

enum RateFilter {
  none,
  one,
  two,
  three,
  four,
  five,
}

@immutable
class SearchState extends Equatable {
  final String search;
  final List<Product> products;
  final List<Product> filteredProducts;
  final SearchPageStatus searchPageStatus;
  final String? errorMessage;
  final PriceFilter priceFilter;
  final CategoryFilter categoryFilter;
  final RateFilter rateFilter;
  final List<String> appliedFilters;

  const SearchState({
    this.search = '',
    this.products = const [],
    this.filteredProducts = const [],
    this.searchPageStatus = SearchPageStatus.initial,
    this.errorMessage,
    this.priceFilter = const PriceFilter(0, 0),
    this.categoryFilter = CategoryFilter.none,
    this.rateFilter = RateFilter.none,
    this.appliedFilters = const [],
  });

  @override
  List<Object?> get props => [
        search,
        products,
        filteredProducts,
        searchPageStatus,
        priceFilter,
        categoryFilter,
        rateFilter,
        appliedFilters,
      ];

  SearchState copyWith({
    String? search,
    List<Product>? products,
    List<Product>? filteredProducts,
    SearchPageStatus? searchPageStatus,
    String? errorMessage,
    PriceFilter? priceFilter,
    CategoryFilter? categoryFilter,
    RateFilter? rateFilter,
    List<String>? appliedFilters,
  }) {
    return SearchState(
      search: search ?? this.search,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchPageStatus: searchPageStatus ?? this.searchPageStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      priceFilter: priceFilter ?? this.priceFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      rateFilter: rateFilter ?? this.rateFilter,
      appliedFilters: appliedFilters ?? this.appliedFilters,
    );
  }
}

class PriceFilter extends Equatable {
  final double start;
  final double end;

  const PriceFilter(this.start, this.end);

  @override
  List<Object?> get props => [
        start,
        end,
      ];
}
