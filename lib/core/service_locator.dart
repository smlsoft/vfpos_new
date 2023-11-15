import 'package:dedepos/core/core.dart';
import 'package:dedepos/features/authentication/auth.dart';
import 'package:dedepos/features/shop/shop.dart';
import 'package:dedepos/features/splash/domain/usecase/check_user_login_status.dart';
import 'package:dedepos/services/user_cache_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> setUpServiceLocator() async {
  // authentication
  serviceLocator.registerFactory<LoginRemoteDataSource>(() => LoginRemoteDataSource());
  serviceLocator.registerFactory<LoginUserRepository>(() => LoginUserRepositoryImpl());
  serviceLocator.registerFactory<LoginUserUseCase>(() => LoginUserUseCase());

  // serviceLocator
  //     .registerFactory<FirebaseAuthentication>(() => FirebaseAuthentication());

  // splash
  serviceLocator.registerFactory<CheckUserLoginStatus>(() => CheckUserLoginStatusImpl());

  // shop
  serviceLocator.registerFactory<ShopRemoteRepository>(() => ShopRemoteRepositoryImpl());
  serviceLocator.registerFactory<ShopAuthenticationRepository>(() => ShopRepositoryData());

  // pos

  //

  //services
  serviceLocator.registerSingleton<UserCacheService>(UserCacheService());
  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerFactory<SharedPreferences>(() => sharedPreferences);

  // core
  serviceLocator.registerSingleton<Request>(Request());
  serviceLocator.registerSingleton<Log>(LogImpl());
}
