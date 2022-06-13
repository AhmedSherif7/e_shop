import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/use_cases/base_use_case.dart';
import '../../../domain/use_cases/get_categories_use_case.dart';
import '../../../domain/use_cases/get_popular_products_use_case.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetPopularProductsUseCase _getHomeProductsUsecase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  HomeCubit(
    this._getHomeProductsUsecase,
    this._getCategoriesUseCase,
  ) : super(const HomeState());

  void getHomeProducts() async {
    emit(
      state.copyWith(
        status: HomeStatus.loading,
      ),
    );

    final result = await _getHomeProductsUsecase(NoParams());
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HomeStatus.error,
            message: failure.message,
          ),
        );
      },
      (resultProducts) {
        final List<Product> offers = [];
        for (var i = 0; i < 5; i++) {
          if (resultProducts[i].discount > 0) {
            offers.add(resultProducts[i]);
          }
        }

        emit(
          state.copyWith(
            products: resultProducts,
            offers: offers,
            status: HomeStatus.success,
          ),
        );
      },
    );
  }

  void getHomeCategories() async {
    if (state.categories.isEmpty) {
      final result = await _getCategoriesUseCase(NoParams());
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: HomeStatus.error,
              message: failure.message,
            ),
          );
        },
        (result) {
          emit(
            state.copyWith(
              categories: result,
              status: HomeStatus.success,
            ),
          );
        },
      );
    }
  }

  int getProductCountInStock(String productId) {
    return state.products
        .firstWhere((product) => product.id == productId)
        .countInStock;
  }
}
