import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/error/failure.dart';
import '../../../data/mappers/mapper.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/add_product_to_cart_use_case.dart';
import '../../../domain/use_cases/add_product_to_favorites_use_case.dart';
import '../../../domain/use_cases/base_use_case.dart';
import '../../../domain/use_cases/change_cart_product_count_use_case.dart';
import '../../../domain/use_cases/get_user_data_use_case.dart';
import '../../../domain/use_cases/log_out_use_case.dart';
import '../../../domain/use_cases/remove_product_from_cart_use_case.dart';
import '../../../domain/use_cases/remove_product_from_favorites_use_case.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserDataUseCase _getUserDataUseCase;
  final AddProductToFavoritesUseCase _addProductToFavoritesUseCase;
  final RemoveProductFromFavoritesUseCase _removeProductFromFavoritesUseCase;
  final AddProductToCartUseCase _addProductToCartUseCase;
  final RemoveProductFromCartUseCase _removeProductFromCartUseCase;
  final ChangeCartProductCountUseCase _changeCartProductCountUseCase;
  final LogoutUseCase logoutUseCase;

  UserBloc(
    this._getUserDataUseCase,
    this._addProductToFavoritesUseCase,
    this._addProductToCartUseCase,
    this._removeProductFromFavoritesUseCase,
    this._removeProductFromCartUseCase,
    this._changeCartProductCountUseCase,
    this.logoutUseCase,
  ) : super(const UserState(userDataStatus: UserDataStatus.loading)) {
    on<UserDataFetched>(_getUserData);
    on<UserProductFavoriteToggled>(_favoriteProductToggle);
    on<UserProductCartToggled>(_cartProductToggle);
    on<UserCartProductCountChanged>(_changeProductCount);
    on<UserLoggedOut>(_logout);
  }

  void _getUserData(UserDataFetched event, Emitter<UserState> emit) async {
    emit(
      state.copyWith(userDataStatus: UserDataStatus.loading),
    );
    final result = await _getUserDataUseCase(NoParams());
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            userDataStatus: UserDataStatus.error,
            message: failure.message,
          ),
        );
      },
      (userData) {
        int totalCount = 0;
        double totalPrice = 0.0;
        for (var productMap in userData.cartProducts) {
          totalCount += productMap['count'] as int;
          totalPrice += double.parse(((productMap['count'] as int) *
                  (productMap['product'].price as double))
              .toStringAsFixed(2));
        }
        emit(
          state.copyWith(
            userDataStatus: UserDataStatus.success,
            user: userData,
            totalCartProducts: totalCount,
            totalPrice: totalPrice,
          ),
        );
      },
    );
  }

  void _favoriteProductToggle(
      UserProductFavoriteToggled event, Emitter<UserState> emit) async {
    late Either<Failure, NoOutput> result;

    if (event.favorites.any((product) => product.id == event.product.id)) {
      result = await _removeProductFromFavoritesUseCase(
        RemoveProductFromFavoritesUseCaseInput(
          event.favorites,
          event.product.id,
        ),
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              userProductStatus: UserProductStatus.removedFromFavoritesError,
              message: failure.message,
            ),
          );
        },
        (output) {
          emit(
            state.copyWith(
              userProductStatus: UserProductStatus.removedFromFavoritesSuccess,
              message: 'Removed from favorites',
            ),
          );
        },
      );
    } else {
      result = await _addProductToFavoritesUseCase(
        AddProductToFavoritesUseCaseInput(
          event.favorites,
          event.product,
        ),
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              userProductStatus: UserProductStatus.addedToFavoritesError,
              message: failure.message,
            ),
          );
        },
        (output) {
          emit(
            state.copyWith(
              userProductStatus: UserProductStatus.addedToFavoritesSuccess,
              message: 'Added to favorites',
            ),
          );
        },
      );
    }
  }

  void _cartProductToggle(
      UserProductCartToggled event, Emitter<UserState> emit) async {
    late Either<Failure, NoOutput> result;

    if (event.cartProducts
        .any((productMap) => productMap['product'].id == event.product.id)) {
      result = await _removeProductFromCartUseCase(
        RemoveProductFromCartUseCaseInput(
          event.cartProducts,
          event.product.id,
        ),
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              userProductStatus: UserProductStatus.removedFromCartError,
              message: failure.message,
            ),
          );
        },
        (output) {
          emit(
            state.copyWith(
              userProductStatus: UserProductStatus.removedFromCartSuccess,
              message: 'Removed from cart',
            ),
          );
        },
      );
    } else {
      result = await _addProductToCartUseCase(
        AddProductToCartUseCaseInput(
          event.cartProducts,
          event.product,
        ),
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              userProductStatus: UserProductStatus.addedToCartError,
              message: failure.message,
            ),
          );
        },
        (output) {
          emit(
            state.copyWith(
              userProductStatus: UserProductStatus.addedToCartSuccess,
              message: 'Added to cart',
            ),
          );
        },
      );
    }
  }

  void _changeProductCount(
      UserCartProductCountChanged event, Emitter<UserState> emit) async {
    final result = await _changeCartProductCountUseCase(
      ChangeCartProductCountUseCaseInput(
        event.cartProducts,
        event.productId,
        event.isAdd,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            userProductStatus: UserProductStatus.changeCartProductCountError,
            message: failure.message,
          ),
        );
      },
      (result) {
        emit(
          state.copyWith(
            userProductStatus: UserProductStatus.changeCartProductCountSuccess,
          ),
        );
        add(UserDataFetched());
      },
    );
  }

  bool isFavorite(String productId) =>
      state.user.favorites.any((product) => product.id == productId);

  bool isInCart(String productId) => state.user.cartProducts
      .any((productMap) => productMap['product'].id == productId);

  void _logout(UserLoggedOut event, Emitter<UserState> emit) async {
    final result = await logoutUseCase(NoParams());
    result.fold(
      (error) {
        emit(
          state.copyWith(
            userDataStatus: UserDataStatus.logoutError,
            message: error.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            userDataStatus: UserDataStatus.logoutSuccess,
          ),
        );
      },
    );
  }
}
