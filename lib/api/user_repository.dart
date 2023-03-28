import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import 'client.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Future<ApiResponse> authenUser(String userName, String passWord) async {
    Dio client = Client().init();

    try {
      final response = await client
          .post('/login', data: {"username": userName, "password": passWord});
      try {
        final result = json.decode(response.toString());
        final rawData = {"success": result["success"], "data": result};

        print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          print(errorMessage);
          throw new Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        print(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      if (ex.type == DioErrorType.connectTimeout) {
        throw Exception('Connection Timeout');
      } else if (ex.type == DioErrorType.receiveTimeout) {
        throw Exception('unable to connect to the server : ' + errorMessage);
      } else if (ex.type == DioErrorType.other) {
        throw Exception(ex.message);
      } else if (ex.type == DioErrorType.response) {
        print(ex.response?.statusCode);
        throw Exception('User Not Found');
      } else {
        throw Exception(errorMessage);
      }
    }
  }

  Future<ApiResponse> getShopList() async {
    Dio client = await Client().init();

    try {
      final response = await client.get('/list-shop');
      try {
        final rawData = json.decode(response.toString());

        print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          print(errorMessage);
          throw new Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        print(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> selectShop(String shopid) async {
    Dio client = Client().init();

    try {
      final response =
          await client.post('/select-shop', data: {"shopid": shopid});
      try {
        final rawData = json.decode(response.toString());

        print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          print(errorMessage);
          throw new Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        print(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }
}
