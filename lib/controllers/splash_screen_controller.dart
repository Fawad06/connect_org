import 'package:connect_org/services/cache_service.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  final cacheService = Get.find<CacheService>();

  bool isFirstTimeStartUp() {
    return cacheService.isFirstTimeStartup();
  }

  bool isLoggedIn() {
    return cacheService.loggedInUserEmail() != null;
  }
}
