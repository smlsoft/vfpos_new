import 'package:dartz/dartz.dart';
import 'package:dedepos/core/failure.dart';
import 'package:dedepos/core/request.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/features/authentication/domain/entity/entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dedepos/features/authentication/data/datasource/login_remote_datasource.dart';

void main() {
  late MockRequest mockRequest;
  late LoginRemoteDataSource loginRemoteDataSource;

  setUpAll(
    () {
      mockRequest = MockRequest();
      serviceLocator.registerFactory<Request>(() => mockRequest);
      loginRemoteDataSource = LoginRemoteDataSource();
    },
  );

  tearDownAll(() async {
    await serviceLocator.reset(dispose: true);
  });

  final UserToken token = UserToken.fromJson({"success": true, "token": "string"});
  final User user = User.fromJson({"name": "string", "username": "string"});
  // final ApiResponse apiResponse =
  //     ApiResponse.fromMap({"success": true, "data": user});

  const apiResponseJson = '{"success": true, "data" : {"name": "string", "username": "string"}}';

  const errorResponseJson = '{"success": false, "message": "error string"}';

  test('should return user model on successful login', () async {
    when(() => mockRequest.post('/login', data: any(named: 'data')))
        .thenAnswer((_) async => Response(statusCode: 200, data: token.toJson(), requestOptions: RequestOptions(baseUrl: '', path: '')));

    when(() => mockRequest.get('/profile')).thenAnswer((_) async => Response(statusCode: 200, data: apiResponseJson, requestOptions: RequestOptions(baseUrl: '', path: '')));

    final response = await loginRemoteDataSource.loginWithUserPassword(username: 'username', password: 'password');

    expect(response, Right(user));
  });

  test('should return user model on successful tokenlogin', () async {
    when(() => mockRequest.post('/tokenlogin', data: any(named: 'data')))
        .thenAnswer((_) async => Response(statusCode: 200, data: token.toJson(), requestOptions: RequestOptions(baseUrl: '', path: '')));

    when(() => mockRequest.get('/profile')).thenAnswer((_) async => Response(statusCode: 200, data: apiResponseJson, requestOptions: RequestOptions(baseUrl: '', path: '')));

    final response = await loginRemoteDataSource.loginWithToken(token: 'token');

    expect(response, Right(user));
  });

  test('should return Failure on error login', () async {
    when(() => mockRequest.post('/tokenlogin', data: any(named: 'data')))
        .thenAnswer((_) async => Response(statusCode: 400, data: errorResponseJson, requestOptions: RequestOptions(baseUrl: '', path: '')));

    final response = await loginRemoteDataSource.loginWithToken(token: 'token');
    expect(response, const Left(ConnectionFailure("error string")));
  });
}

class MockRequest extends Mock implements Request {}
