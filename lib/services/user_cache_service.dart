import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/core.dart';
import '../features/auth/auth.dart';

const String USER_CACHE_KEY = 'usercache';

class UserCacheService {
  User? _user;
  User? get user => _user;
  SharedPreferences get sharedPrefs => serviceLocator<SharedPreferences>();

  Future<User?> getUser() async {
    User usr;
    var userMap = sharedPrefs.getString(USER_CACHE_KEY);
    if (userMap == null) {
      return null;
    }
    usr = User.fromJson(jsonDecode(userMap));
    _user = usr;
    return usr;
  }

  Future<void> saveUser(User user) async {}
}
