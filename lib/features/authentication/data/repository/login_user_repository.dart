import 'package:dartz/dartz.dart';
import 'package:dedepos/core/core.dart';
import 'package:dedepos/features/authentication/data/datasource/login_remote_datasource.dart';
import 'package:dedepos/features/authentication/domain/entity/user.dart';
import 'package:dedepos/features/authentication/domain/repository/authentication_user_repository.dart';

class LoginUserRepositoryImpl extends LoginUserRepository {
  @override
  Future<Either<Failure, User>> loginWithToken({required String token}) {
    return serviceLocator<LoginRemoteDataSource>().loginWithToken(token: token);
  }

  @override
  Future<Either<Failure, User>> loginWithUserPassword({required String username, required String password}) async {
    return serviceLocator<LoginRemoteDataSource>().loginWithUserPassword(username: username, password: password);
  }

  @override
  Future<Either<Failure, User>> profile() {
    return serviceLocator<LoginRemoteDataSource>().profile();
  }
}
