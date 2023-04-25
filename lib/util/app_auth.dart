import 'dart:async';
import 'dart:math';

class AuthService {
  // Login
  Future<bool> login() async {
    // Simulate a future for response after 2 second.
    return await Future<bool>.delayed(
        const Duration(seconds: 2), () => Random().nextBool());
  }

  // Logout
  Future<void> logout() async {
    // Simulate a future for response after 1 second.
    return await Future<void>.delayed(const Duration(seconds: 1));
  }
}
