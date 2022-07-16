import 'package:connect_org/services/api_service.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/ui/logins_screen/login_screen.dart';
import 'package:connect_org/ui/navigation_screen/navigation_screen.dart';
import 'package:connect_org/widgets/password_field.dart';
import 'package:get/get.dart';

import '../services/cache_service.dart';

class AuthController extends GetxController {
  final apiService = Get.find<ApiService>();
  final userService = Get.find<UserService>();
  final cacheService = Get.find<CacheService>();

  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString username = "".obs;
  RxString email = "".obs;
  RxString errorString = "".obs;
  RxBool isBusy = false.obs;
  RxBool isManager = false.obs;

  final ObscuringTextEditingController obscuringPasswordController =
      ObscuringTextEditingController();

  void signIn() async {
    try {
      isBusy.value = true;
      final user = await apiService.signIn(
        email.value,
        obscuringPasswordController.text,
      );
      userService.updateUser(user);
      await cacheService.setUserEmail(user.email);
      Get.offAll(() => const NavigationScreen());
    } catch (e) {
      errorString.value = e.toString();
    } finally {
      isBusy.value = false;
    }
  }

  void signUp() async {
    try {
      isBusy.value = true;
      await apiService.signUp(
        firstName.value,
        lastName.value,
        username.value,
        email.value,
        obscuringPasswordController.text,
        isManager.value,
      );
      Get.off(() => LoginScreen());
    } catch (e) {
      errorString.value = e.toString();
    } finally {
      isBusy.value = false;
    }
  }

  void clearVariables() {
    obscuringPasswordController.clear();
    firstName.value = "";
    lastName.value = "";
    username.value = "";
    email.value = "";
    errorString.value = "";
  }

  void resetForgottenPassword() async {
    try {
      isBusy.value = true;
      await apiService.resetForgottenPassword(email.value);
      errorString.value = "Password Reset email was sent to the given address.";
    } catch (e) {
      errorString.value = e.toString();
    } finally {
      isBusy.value = false;
    }
  }
}
