import 'package:iron_mine/core/utils/preference_manger.dart';

import 'constants.dart';

class TokenUtil {
  static String _token = '';
  static String _role = '';

  static Future<void> loadTokenAndRoleToMemory() async {
    _token = await PreferenceManager.getInstance().getString(Constants.token);
    _role = await PreferenceManager.getInstance().getString(Constants.role);
  }

  static String getTokenFromMemory() {
    return _token;
  }

  static String getRoleFromMemory() {
    return _role;
  }

  static void saveToken(String token) {
    PreferenceManager.getInstance().saveString(Constants.token, token);
    loadTokenAndRoleToMemory();
  }

  static void clearToken() {
    PreferenceManager.getInstance().remove(Constants.token);
    _token = '';
  }
}
