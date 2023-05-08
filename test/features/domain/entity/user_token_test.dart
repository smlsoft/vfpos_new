import 'package:dedepos/core/models/api_response.dart';
import 'package:dedepos/features/authentication/domain/entity/entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('user', () {
    test('from json should return usertoken object', () {
      final jsonData = {"success": true, "token": "xxx"};
      final userToken = UserToken.fromJson(jsonData);
      expect(userToken.token, "xxx");
    });

    test('from json should return user object', () {
      final jsonData = {
        "success": true,
        "data": {"name": "string", "username": "string"}
      };

      final ApiResponse response = ApiResponse.fromMap(jsonData);

      final userToken = User.fromJson(response.data);
      expect(userToken.name, "string");
    });
  });
}
