import 'dart:convert';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/features/authentication/domain/entity/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USER_CACHE_KEY = 'usercache';

class UserCacheService {
  User? _user;
  User? get user => _user;

  SharedPreferences get sharedPrefers => serviceLocator<SharedPreferences>();

  Future<bool> saveUser(User user) async {
    var map = user.toJson();
    bool saved = await sharedPrefers.setString(USER_CACHE_KEY, jsonEncode(map));
    if (saved) {
      _user = await getUser();
    }
    return saved;
  }

  Future<User?> getUser() async {
    User usr;
    var userMap = sharedPrefers.getString(USER_CACHE_KEY);
    if (userMap == null) {
      return null;
    }
    usr = User.fromJson(jsonDecode(userMap));
    _user = usr;
    return usr;
  }

  Future<bool> deleteUser() async {
    _user = null;
    return await sharedPrefers.remove(USER_CACHE_KEY);
  }
}
