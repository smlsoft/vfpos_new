import 'package:dedepos/app/app_constant.dart';
import 'package:dedepos/core/environment.dart';
import 'package:dedepos/bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    initializeEnvironmentConfig();
  });

  test('test environment', () {
    expect(Environment().config.serviceApi, AppConstant.serviceDevApi);
    expect(Environment().isDev, true);
  });
}
