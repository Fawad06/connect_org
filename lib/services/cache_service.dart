import 'package:connect_org/utils/log_extension.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService extends GetxService {
  SharedPreferences? _pref;

  Future ensureInitialized() async {
    _pref = await SharedPreferences.getInstance();
  }

  String? loggedInUserEmail() {
    return _pref?.getString("loggedInUser");
  }

  bool isFirstTimeStartup() {
    final value = _pref?.getBool("isFirstTime");
    if (value == null) {
      _pref?.setBool("isFirstTime", true);
      return true;
    } else {
      return false;
    }
  }

  Future setUserEmail(String? email) async {
    if (email != null) {
      await _pref?.setString("loggedInUser", email);
      "Message from CacheService: user email saved.".log();
    } else {
      await _pref?.remove("loggedInUser");
      "Message from CacheService: user email removed.".log();
    }
  }
}
