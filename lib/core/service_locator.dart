import 'package:dedepos/features/splash/domain/usecase/check_user_login_status.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  serviceLocator
      .registerFactory<CheckUserLoginStatus>(() => CheckUserLoginStatusImpl());

  // final sharedPreferences = await SharedPreferences.getInstance();
  // serviceLocator.registerFactory<SharedPreferences>(() => sharedPreferences);
}
