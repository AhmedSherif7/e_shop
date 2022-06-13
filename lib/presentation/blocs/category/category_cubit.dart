import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/use_cases/get_category_products_use_case.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoryProductsUseCase getCategoryProductsUseCase;

  CategoryCubit(this.getCategoryProductsUseCase) : super(const CategoryState());

  void getProducts(String name) async {
    emit(
      state.copyWith(
        pageStatus: PageStatus.loading,
      ),
    );

    final result = await getCategoryProductsUseCase(name);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (products) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.success,
            products: products,
          ),
        );
      },
    );
  }
}
