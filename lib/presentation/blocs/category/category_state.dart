part of 'category_cubit.dart';

enum PageStatus {
  loading,
  success,
  error,
}

@immutable
class CategoryState extends Equatable {
  final PageStatus pageStatus;
  final List<Product> products;
  final String? errorMessage;

  const CategoryState({
    this.pageStatus = PageStatus.loading,
    this.products = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageStatus,
        products,
      ];

  CategoryState copyWith({
    PageStatus? pageStatus,
    List<Product>? products,
    String? errorMessage,
  }) {
    return CategoryState(
      pageStatus: pageStatus ?? this.pageStatus,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
