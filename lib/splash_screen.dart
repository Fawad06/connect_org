import 'package:connect_org/controllers/chat_controller.dart';
import 'package:connect_org/generated/assets.dart';
import 'package:connect_org/services/api_service.dart';
import 'package:connect_org/services/cache_service.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/ui/logins_screen/login_screen.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'controllers/auth_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/jobs_controller.dart';
import 'controllers/organizations_controller.dart';
import 'controllers/splash_screen_controller.dart';
import 'ui/navigation_screen/navigation_screen.dart';
import 'ui/onboarding_screen/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          Future.delayed(kDefaultAnimationDuration),
          initializeControllers(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final controller = Get.find<SplashScreenController>();
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                if (controller.isFirstTimeStartUp()) {
                  Get.offAll(() => OnboardingView());
                } else if (controller.isLoggedIn()) {
                  Get.offAll(() => const NavigationScreen());
                } else {
                  Get.offAll(() => LoginScreen());
                }
              });
            }
          }
          return SizedBox.expand(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                Assets.imagesConnectOrgLogo,
                width: 20.h,
                height: 20.h,
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> initializeControllers() async {
  //putting api service first as it do not depend on others
  Get.put(ApiService());

  ///putting cache service
  final cacheService = CacheService();
  await cacheService.ensureInitialized();
  Get.put(cacheService);

  ///putting user service
  final userService = UserService();
  await userService.ensureInitialized();
  Get.put(userService);

  ///putting rest of the controllers
  Get.lazyPut(() => SplashScreenController());
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => ChatController(), fenix: true);
  Get.lazyPut(() => OrganizationsController(), fenix: true);
  Get.lazyPut(() => JobsController(), fenix: true);
}
