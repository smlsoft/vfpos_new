import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/services/services.dart';

abstract class CheckUserLoginStatus {
  Future<bool> checkIfUserLoggedIn();
}

class CheckUserLoginStatusImpl extends CheckUserLoginStatus {
  @override
  Future<bool> checkIfUserLoggedIn() async {
    // final user = await serviceLocator<UserCacheService>().getUser();
    // return user != null;
    return false;
  }
}
