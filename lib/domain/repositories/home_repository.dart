import 'package:dartz/dartz.dart';

import '../../data/error/failure.dart';
import '../entities/category.dart';
import '../entities/product.dart';
import '../use_cases/base_use_case.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Product>>> getPopularProducts();

  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Product>>> productSearch(String search);

  Future<Either<Failure, List<Product>>> getCategoryProducts(String name);

  Future<Either<Failure, NoOutput>> downloadProductImage(
    String url,
    String name,
  );

  Future<Either<Failure, NoOutput>> watchOnBoardScreen();

  Future<Either<Failure, NoOutput>> toggleTheme(bool value);

  Future<Either<Failure, bool>> getThemeFromStorage();
}
