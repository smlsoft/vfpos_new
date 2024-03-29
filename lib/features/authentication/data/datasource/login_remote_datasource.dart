import 'package:dartz/dartz.dart';
import 'package:dedepos/core/core.dart';
import 'package:dedepos/features/authentication/domain/entity/entity.dart';
import 'package:flutter/material.dart';

abstract class ILoginRemoteDataSource {
  Future<Either<Failure, User>> loginWithUserPassword({required String username, required String password});
  Future<Either<Failure, User>> loginWithToken({required String token});
  Future<Either<Failure, User>> profile();
}

class LoginRemoteDataSource implements ILoginRemoteDataSource {
  final Request request = serviceLocator<Request>();

  @override
  Future<Either<Failure, User>> loginWithToken({required String token}) async {
    try {
      request.updateDioInterceptors();
      final response = await request.post('/tokenlogin', data: {"token": token});
      final result = Json.decode(response.toString());

      if (response.statusCode == 200) {
        UserToken token = UserToken.fromJson(result);

        request.updateAuthorization(token.token);

        final userResponse = await request.get('/profile');
        final userResult = Json.decode(userResponse.toString());
        ApiResponse responseGetProfile = ApiResponse.fromMap(userResult);

        User user = User.fromJson(responseGetProfile.data);
        user = user.copyWith(token: token.token);

        return Right(user);
      }

      String errorMessage = '${result['message']}';
      return Left(ConnectionFailure(errorMessage));
    } catch (e) {
      debugPrint('LoginRemoteDataSourceImplError $e');
      return const Left(
        Exception('Exception Occurred in LoginRemoteDataSource'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> loginWithUserPassword({required String username, required String password}) async {
    try {
      request.updateAuthDioInterceptors();
      final response = await request.post('/external-login', data: {"username": username, "password": password, "channel": "pos"});
      var resultLogin = {"status": "error", "message": "", "code": 0, "token": ""};
      var result = Json.decode(response.toString());
      request.updateDioInterceptors();
      if (result['code'] == 401) {
        final responseDev = await request.post('/login', data: {"username": username, "password": password});
        final resultDev = Json.decode(responseDev.toString());
        if (resultDev['success']) {
          resultLogin['status'] = 'success';
          resultLogin['message'] = '';
          resultLogin['code'] = 200;
          resultLogin['token'] = resultDev['token'];
        } else {
          return Left(ConnectionFailure(resultDev['message']));
        }
      } else if (result['code'] == 200) {
        resultLogin['status'] = 'success';
        resultLogin['message'] = '';
        resultLogin['code'] = 200;

        final resToken = await request.post('/vftokenlogin', data: {"usercode": username, "token": result['data']['access_token']});
        final resultToken = Json.decode(resToken.toString());
        if (!resultToken['success']) {
          return Left(ConnectionFailure(resultToken['message']));
        }
        resultLogin['token'] = resultToken['token'];
      } else {
        resultLogin['status'] = result['status'];
        resultLogin['message'] = result['message'];
        resultLogin['code'] = result['code'];
      }
      if (resultLogin['status'] == 'success') {
        UserToken token = UserToken.fromJson(resultLogin);

        request.updateAuthorization(token.token);

        final userResponse = await request.get('/profile');
        final userResult = Json.decode(userResponse.toString());
        ApiResponse responseGetProfile = ApiResponse.fromMap(userResult);

        User user = User.fromJson(responseGetProfile.data);

        user = user.copyWith(token: token.token, refresh: token.token);

        return Right(user);
      }

      String errorMessage = '${result['code']}: ${result['message']}';
      return Left(ConnectionFailure(errorMessage));
    } catch (e) {
      debugPrint('LoginRemoteDataSourceImplError $e');
      return const Left(
        Exception('Exception Occurred in LoginRemoteDataSource'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> profile() async {
    try {
      final response = await request.get('/profile');
      final result = Json.decode(response.toString());

      if (response.statusCode == 200) {
        ApiResponse responseGetProfile = ApiResponse.fromMap(result);
        User user = User.fromJson(responseGetProfile.data);
        return right(user);
      }

      return const Left(Exception('Exception Occurred in LoginRemoteDataSource'));
    } catch (e) {
      debugPrint('LoginRemoteDataSourceImplError $e');
      return const Left(
        Exception('Exception Occurred in LoginRemoteDataSource'),
      );
    }
  }
}
