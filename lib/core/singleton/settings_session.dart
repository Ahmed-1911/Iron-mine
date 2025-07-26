import 'package:iron_mine/core/utils/constants.dart';
import 'package:iron_mine/core/utils/preference_manger.dart';

class SettingsSession {
  static final SettingsSession _instance = SettingsSession._internal();
  String _languageCode = 'en';

  void loadLanguage() {
    PreferenceManager.getInstance()
        .getString(Constants.languageCode)
        .then((value) {
      if (value.isEmpty) {
        PreferenceManager.getInstance()
            .saveString(Constants.languageCode, 'en');
        _languageCode = 'en';
      } else {
        _languageCode = value;
      }
    });
  }

  String get languageCode => _languageCode;

  void changeLanguageCode(String lang) {
    _languageCode = lang;
  }

  static SettingsSession instance() {
    return _instance;
  }

  void destroy() {}

  SettingsSession._internal();
}
