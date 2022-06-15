import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_sources/local_data_source.dart';
import '../data/data_sources/payment_data_source.dart';
import '../data/data_sources/remote_data_source.dart';
import '../data/network/dio_factory.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/main_repository_impl.dart';
import '../data/repositories/payment_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/main_repository.dart';
import '../domain/repositories/payment_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/use_cases/add_product_to_cart_use_case.dart';
import '../domain/use_cases/add_product_to_favorites_use_case.dart';
import '../domain/use_cases/add_voucher_use_case.dart';
import '../domain/use_cases/change_cart_product_count_use_case.dart';
import '../domain/use_cases/download_product_image_use_case.dart';
import '../domain/use_cases/get_categories_use_case.dart';
import '../domain/use_cases/get_category_products_use_case.dart';
import '../domain/use_cases/get_image_from_gallery_use_case.dart';
import '../domain/use_cases/get_popular_products_use_case.dart';
import '../domain/use_cases/get_theme_from_storage_use_case.dart';
import '../domain/use_cases/get_user_address_use_case.dart';
import '../domain/use_cases/get_user_data_use_case.dart';
import '../domain/use_cases/get_user_location_use_case.dart';
import '../domain/use_cases/get_user_orders_use_case.dart';
import '../domain/use_cases/log_out_use_case.dart';
import '../domain/use_cases/login_use_case.dart';
import '../domain/use_cases/make_order_use_case.dart';
import '../domain/use_cases/make_payment_use_case.dart';
import '../domain/use_cases/product_search_use_case.dart';
import '../domain/use_cases/register_use_case.dart';
import '../domain/use_cases/remove_product_from_cart_use_case.dart';
import '../domain/use_cases/remove_product_from_favorites_use_case.dart';
import '../domain/use_cases/toggle_theme_use_case.dart';
import '../domain/use_cases/update_user_data_use_case.dart';
import '../domain/use_cases/watch_onboarding_use_case.dart';
import '../presentation/blocs/category/category_cubit.dart';
import '../presentation/blocs/checkout/checkout_cubit.dart';
import '../presentation/blocs/home/home_cubit.dart';
import '../presentation/blocs/login/login_cubit.dart';
import '../presentation/blocs/on_boarding/on_boarding_bloc_cubit.dart';
import '../presentation/blocs/orders/orders_cubit.dart';
import '../presentation/blocs/product_images/product_images_cubit.dart';
import '../presentation/blocs/register/register_cubit.dart';
import '../presentation/blocs/search/search_cubit.dart';
import '../presentation/blocs/theme/theme_cubit.dart';
import '../presentation/blocs/user/user_bloc.dart';
import '../presentation/blocs/user_info/user_info_cubit.dart';

final sl = GetIt.instance;

Future<void> initAppModule() async {
  if (!sl.isRegistered<ThemeCubit>()) {
    sl.registerFactory<ThemeCubit>(
      () => ThemeCubit(
        sl(),
        sl(),
      ),
    );
  }

  if (!sl.isRegistered<ToggleThemeUseCase>()) {
    sl.registerLazySingleton<ToggleThemeUseCase>(
      () => ToggleThemeUseCase(
        sl(),
      ),
    );
  }

  if (!sl.isRegistered<GetThemeFromStorageUseCase>()) {
    sl.registerLazySingleton<GetThemeFromStorageUseCase>(
      () => GetThemeFromStorageUseCase(
        sl(),
      ),
    );
  }

  // repositories
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplementer(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );
  }

  if (!sl.isRegistered<MainRepository>()) {
    sl.registerLazySingleton<MainRepository>(
      () => MainRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );
  }

  // data sources
  if (!sl.isRegistered<RemoteDataSource>()) {
    sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(sl()),
    );
  }

  if (!sl.isRegistered<LocalDataSource>()) {
    sl.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(
        sl(),
        sl(),
      ),
    );
  }

  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerLazySingleton(() => sharedPreferences);
  }

  final dio = await DioFactory.getDio();
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() => dio);
  }

  if (!sl.isRegistered<ImagePicker>()) {
    sl.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

void initOnBoardingModule() {
  if (!sl.isRegistered<OnBoardingCubit>()) {
    sl.registerFactory<OnBoardingCubit>(
      () => OnBoardingCubit(sl()),
    );
  }

  if (!sl.isRegistered<WatchOnBoardingUseCase>()) {
    sl.registerLazySingleton(() => WatchOnBoardingUseCase(sl()));
  }
}

void initLoginModule() {
  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerFactory<LoginUseCase>(() => LoginUseCase(sl()));
  }

  if (!sl.isRegistered<LoginCubit>()) {
    sl.registerFactory<LoginCubit>(
      () => LoginCubit(sl()),
    );
  }
}

void initRegisterModule() {
  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerLazySingleton(() => RegisterUseCase(sl()));
  }

  if (!sl.isRegistered<RegisterCubit>()) {
    sl.registerFactory<RegisterCubit>(
      () => RegisterCubit(sl()),
    );
  }
}

void initHomeModule() {
  if (!sl.isRegistered<UserRepository>()) {
    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
      ),
    );
  }

  if (!sl.isRegistered<UserBloc>()) {
    sl.registerFactory<UserBloc>(
      () => UserBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );
  }

  if (!sl.isRegistered<HomeCubit>()) {
    sl.registerFactory<HomeCubit>(
      () => HomeCubit(
        sl(),
        sl(),
      ),
    );
  }

  if (!sl.isRegistered<GetUserDataUseCase>()) {
    sl.registerLazySingleton(() => GetUserDataUseCase(sl()));
  }
  if (!sl.isRegistered<AddProductToFavoritesUseCase>()) {
    sl.registerLazySingleton(() => AddProductToFavoritesUseCase(sl()));
  }
  if (!sl.isRegistered<AddProductToCartUseCase>()) {
    sl.registerLazySingleton(() => AddProductToCartUseCase(sl()));
  }
  if (!sl.isRegistered<RemoveProductFromFavoritesUseCase>()) {
    sl.registerLazySingleton(() => RemoveProductFromFavoritesUseCase(sl()));
  }
  if (!sl.isRegistered<RemoveProductFromCartUseCase>()) {
    sl.registerLazySingleton(() => RemoveProductFromCartUseCase(sl()));
  }
  if (!sl.isRegistered<ChangeCartProductCountUseCase>()) {
    sl.registerLazySingleton(() => ChangeCartProductCountUseCase(sl()));
  }
  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerLazySingleton(() => LogoutUseCase(sl()));
  }

  if (!sl.isRegistered<GetPopularProductsUseCase>()) {
    sl.registerLazySingleton(() => GetPopularProductsUseCase(sl()));
  }
  if (!sl.isRegistered<GetCategoriesUseCase>()) {
    sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  }
}

void initCategoriesModule() {
  if (!sl.isRegistered<CategoryCubit>()) {
    sl.registerFactory<CategoryCubit>(
      () => CategoryCubit(sl()),
    );
  }

  if (!sl.isRegistered<GetCategoryProductsUseCase>()) {
    sl.registerLazySingleton(() => GetCategoryProductsUseCase(sl()));
  }
}

void initCheckoutModule() {
  if (!sl.isRegistered<PaymentDataSource>()) {
    sl.registerLazySingleton<PaymentDataSource>(
      () => PaymentDataSourceImpl(sl()),
    );
  }

  if (!sl.isRegistered<PaymentRepository>()) {
    sl.registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(
        paymentDataSource: sl(),
      ),
    );
  }

  if (!sl.isRegistered<CheckoutCubit>()) {
    sl.registerFactory<CheckoutCubit>(
      () => CheckoutCubit(
        sl(),
        sl(),
        sl(),
      ),
    );
  }

  if (!sl.isRegistered<AddVoucherUseCase>()) {
    sl.registerLazySingleton(() => AddVoucherUseCase(sl()));
  }
  if (!sl.isRegistered<MakePaymentUseCase>()) {
    sl.registerLazySingleton(() => MakePaymentUseCase(sl()));
  }
  if (!sl.isRegistered<MakeOrderUseCase>()) {
    sl.registerLazySingleton(() => MakeOrderUseCase(sl()));
  }
}

void initSearchModule() {
  if (!sl.isRegistered<SearchCubit>()) {
    sl.registerFactory<SearchCubit>(
      () => SearchCubit(sl()),
    );
  }

  if (!sl.isRegistered<ProductSearchUseCase>()) {
    sl.registerLazySingleton(() => ProductSearchUseCase(sl()));
  }
}

void initUserInfoModule() {
  if (!sl.isRegistered<UserInfoCubit>()) {
    sl.registerFactory<UserInfoCubit>(
      () => UserInfoCubit(
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );
  }

  if (!sl.isRegistered<GetImageFromGalleryUseCase>()) {
    sl.registerLazySingleton(() => GetImageFromGalleryUseCase(sl()));
  }
  if (!sl.isRegistered<GetUserLocationUseCase>()) {
    sl.registerLazySingleton(() => GetUserLocationUseCase(sl()));
  }
  if (!sl.isRegistered<GetUserAddressUseCase>()) {
    sl.registerLazySingleton(() => GetUserAddressUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateUserDataUseCase>()) {
    sl.registerLazySingleton(() => UpdateUserDataUseCase(sl()));
  }
}

void initUserOrdersModule() {
  if (!sl.isRegistered<OrdersCubit>()) {
    sl.registerFactory<OrdersCubit>(
      () => OrdersCubit(sl()),
    );
  }

  if (!sl.isRegistered<GetUserOrdersUseCase>()) {
    sl.registerLazySingleton(() => GetUserOrdersUseCase(sl()));
  }
}

void initProductImageModule() {
  if (!sl.isRegistered<ProductImagesCubit>()) {
    sl.registerFactory<ProductImagesCubit>(
      () => ProductImagesCubit(sl()),
    );
  }

  if (!sl.isRegistered<DownLoadProductImageUseCase>()) {
    sl.registerLazySingleton(() => DownLoadProductImageUseCase(sl()));
  }
}

Future<void> resetModules() async {
  await sl.reset(dispose: false);
  await initAppModule();
}
