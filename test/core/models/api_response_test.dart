import 'package:dedepos/core/models/api_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test phase response from api', () {
    final jsonData = {
      "success": true,
      "data": {"name": "string", "username": "string"}
    };

    final userToken = ApiResponse.fromMap(jsonData);
    expect(true, userToken.success);
  });
}
