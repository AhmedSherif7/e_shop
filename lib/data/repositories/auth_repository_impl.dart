import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app/di.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/base_use_case.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';
import '../error/failure.dart';

class AuthRepositoryImplementer extends AuthRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  AuthRepositoryImplementer({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, NoOutput>> login(
    String email,
    String password,
  ) async {
    try {
      final userId = await remoteDataSource.login(
        email,
        password,
      );

      await localDataSource.cacheUserId(userId);
      return Right(NoOutput());
    } on FirebaseAuthException catch (e) {
      return Left(LoginFailure.fromCode(e.code));
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, NoOutput>> register(
    String email,
    String password,
  ) async {
    try {
      await remoteDataSource.register(
        email,
        password,
      );
      return Right(NoOutput());
    } on FirebaseAuthException catch (e) {
      return Left(RegisterFailure.fromCode(e.code));
    } catch (_) {
      throw UnknownFailure();
    }
  }

  @override
  Future<Either<Failure, NoOutput>> logout() async {
    try {
      await localDataSource.removeUserId();
      await remoteDataSource.logout();
      await resetModules();
      return Right(NoOutput());
    } catch (_) {
      return const Left(Failure(message: 'Could not log out'));
    }
  }
}
