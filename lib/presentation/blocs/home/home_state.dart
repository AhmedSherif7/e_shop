part of 'home_cubit.dart';

enum HomeStatus {
  loading,
  error,
  success,
}

@immutable
class HomeState extends Equatable {
  final List<Product> products;
  final List<Product> offers;
  final List<Category> categories;
  final HomeStatus status;
  final String? message;

  const HomeState({
    this.products = const [],
    this.offers = const [],
    this.categories = const [],
    this.status = HomeStatus.loading,
    this.message,
  });

  @override
  List<Object?> get props => [
        products,
        offers,
        categories,
        status,
      ];

  HomeState copyWith({
    List<Product>? products,
    List<Product>? offers,
    List<Category>? categories,
    HomeStatus? status,
    String? message,
  }) {
    return HomeState(
      products: products ?? this.products,
      offers: offers ?? this.offers,
      categories: categories ?? this.categories,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
