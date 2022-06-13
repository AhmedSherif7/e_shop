import 'package:dartz/dartz.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/use_cases/base_use_case.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';
import '../error/failure.dart';

class HomeRepositoryImpl implements HomeRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getPopularProducts() async {
    try {
      final result = await remoteDataSource.getPopularProducts();
      return Right(result);
    } catch (_) {
      return const Left(Failure(message: 'Failed to get products'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Right(result);
    } catch (_) {
      return const Left(Failure(message: 'Failed to get categories'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> productSearch(String search) async {
    try {
      final result = await remoteDataSource.productSearch(search);
      return Right(result);
    } catch (_) {
      return const Left(Failure(message: 'Error happened while searching'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getCategoryProducts(
      String name) async {
    try {
      final result = await remoteDataSource.getCategoryProducts(name);
      return Right(result);
    } catch (_) {
      return const Left(Failure(message: 'Failed to get products'));
    }
  }

  @override
  Future<Either<Failure, NoOutput>> downloadProductImage(
      String url, String name) async {
    try {
      await remoteDataSource.downloadProductImage(url, name);
      return Right(NoOutput());
    } on Failure catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return const Left(Failure(message: 'Failed to download image'));
    }
  }

  @override
  Future<Either<Failure, NoOutput>> watchOnBoardScreen() async {
    try {
      await localDataSource.watchOnBoardScreen();
      return Right(NoOutput());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, NoOutput>> toggleTheme(bool value) async {
    try {
      await localDataSource.toggleTheme(value);
      return Right(NoOutput());
    } catch (_) {
      return const Left(Failure(message: 'Failed to save theme'));
    }
  }

  @override
  Future<Either<Failure, bool>> getThemeFromStorage() async {
    try {
      final result = await localDataSource.getThemeFromStorage();
      return Right(result);
    } catch (_) {
      return const Left(Failure(message: 'Failed to get theme from storage'));
    }
  }
}
