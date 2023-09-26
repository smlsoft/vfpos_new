import 'dart:convert';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';

import 'client.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Future<ApiResponse> authenUser(String userName, String passWord) async {
    Dio client = Client().init();

    try {
      final response = await client.post('/login', data: {"username": userName, "password": passWord});
      try {
        final result = json.decode(response.toString());
        final rawData = {"success": result["success"], "data": result};

        serviceLocator<Log>().trace(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      if (ex.type == DioErrorType.sendTimeout) {
        throw Exception('Connection Timeout');
      } else if (ex.type == DioErrorType.receiveTimeout) {
        throw Exception('unable to connect to the server : $errorMessage');
      } else if (ex.type == DioErrorType.unknown) {
        throw Exception(ex.message);
      } else if (ex.type == DioErrorType.badResponse) {
        serviceLocator<Log>().error(ex.response?.statusCode);
        throw Exception('User Not Found');
      } else {
        throw Exception(errorMessage);
      }
    }
  }

  Future<ApiResponse> getShopList() async {
    Dio client = Client().init();

    try {
      final response = await client.get('/list-shop');
      try {
        final rawData = json.decode(response.toString());

        serviceLocator<Log>().debug(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().debug(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> selectShop(String shopid) async {
    Dio client = Client().init();

    try {
      final response = await client.post('/select-shop', data: {"shopid": shopid});
      try {
        final rawData = json.decode(response.toString());

        serviceLocator<Log>().debug(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }
}
