import 'package:connect_org/controllers/chat_controller.dart';
import 'package:connect_org/models/chat_model.dart';
import 'package:connect_org/models/job_model.dart';
import 'package:connect_org/models/user_model.dart';
import 'package:connect_org/services/cache_service.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/ui/logins_screen/login_screen.dart';
import 'package:connect_org/utils/log_extension.dart';
import 'package:get/get.dart';

import '../models/organization_model.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final apiService = Get.find<ApiService>();
  final userService = Get.find<UserService>();
  final cacheService = Get.find<CacheService>();
  final chatController = Get.find<ChatController>();
  RxList<Organization> organizations = <Organization>[].obs;
  RxList<Job> jobs = <Job>[].obs;
  RxList<Chat> chats = <Chat>[].obs;
  RxList<MyNotification> notifications = <MyNotification>[].obs;
  RxBool isBusy = false.obs;

  Rx<MyUser?> get user => userService.user;

  @override
  onInit() {
    _loadInitialData();
    super.onInit();
  }

  Future _loadInitialData() async {
    isBusy.value = true;
    await Future.wait([
      _loadAllOrganizations(),
      _loadAllJobs(),
      _loadAllChats(),
      // _loadNotifications(),
    ]);
    isBusy.value = false;
  }

  Future _loadAllOrganizations() async {
    try {
      final allOrg = await apiService.getAllOrganizations();
      organizations.assignAll(allOrg);
      "Message from HomeController: Organizations loaded".log();
    } catch (e) {
      "Message from HomeController: Error loading organizations:${e.toString()}"
          .log();
    }
  }

  Future _loadAllJobs() async {
    try {
      final allJobs = await apiService.getAllJobs();
      jobs.assignAll(allJobs);
      "Message from HomeController: Jobs loaded".log();
    } catch (e) {
      "Message from HomeController: Error loading Jobs:${e.toString()}".log();
    }
  }

  Future _loadAllChats() async {
    try {
      List<Chat> allChats = [];
      if (user.value!.userType == "Manager") {
        if (userService.myOrganizations.isEmpty) {
          await userService.loadMyOrganizations();
        }
        for (Organization org in userService.myOrganizations) {
          allChats.addAll(await apiService.getAllChats(org.id));
        }
      } else {
        allChats = await apiService.getAllChats(user.value!.id);
      }
      chats.assignAll(allChats);
      "Message from HomeController: Chats loaded".log();
    } catch (e) {
      "Message from HomeController: Error loading Chats:${e.toString()}".log();
    }
  }

  Future logout() async {
    try {
      isBusy.value = true;
      await cacheService.setUserEmail(null);
      isBusy.value = false;
      Get.offAll(() => LoginScreen());
    } catch (e) {
      "Message from HomeController: Error logging out:${e.toString()}".log();
      isBusy.value = false;
    }
  }

  Future<void> likeUnLikeOrganization(
    bool isLiked,
    String organizationId,
  ) async {
    try {
      if (isLiked) {
        final isLikedSuccess = await apiService.likeOrganization(
          user.value!.id,
          organizationId,
        );
        if (isLikedSuccess) {
          userService.addLikedOrganization(organizationId);
          final likedOrgIndex = organizations.indexWhere(
            (element) => element.id == organizationId,
          );
          organizations[likedOrgIndex] = organizations[likedOrgIndex].copyWith(
            likes: organizations[likedOrgIndex].likes + 1,
          );
        }
      } else {
        final unLikedSuccess = await apiService.unLikeOrganization(
          user.value!.id,
          organizationId,
        );
        if (unLikedSuccess) {
          userService.removeUnLikedOrganization(organizationId);
          final unlikedOrgIndex = organizations.indexWhere(
            (element) => element.id == organizationId,
          );
          organizations[unlikedOrgIndex] =
              organizations[unlikedOrgIndex].copyWith(
            likes: organizations[unlikedOrgIndex].likes - 1,
          );
        }
      }
    } catch (e) {
      "Message from HomeController: Error logging out:${e.toString()}".log();
    }
  }

  Future refreshOrgData() async {
    isBusy.value = true;
    await _loadAllOrganizations();
    isBusy.value = false;
  }

  Future refreshJobData() async {
    isBusy.value = true;
    await _loadAllJobs();
    isBusy.value = false;
  }

  Future refreshChatData() async {
    isBusy.value = true;
    await _loadAllChats();
    isBusy.value = false;
  }

  Future refreshNotificationData() async {
    isBusy.value = true;
    await _loadAllNotifications();
    isBusy.value = false;
  }

  Future _loadAllNotifications() async {
    // try {
    //   final allNotifications = await apiService.getAllNotifications();
    //   notifications.assignAll(allNotifications);
    //   "Message from HomeController: Notifications loaded".log();
    // } catch (e) {
    //   "Message from HomeController: Error loading Notifications:${e.toString()}"
    //       .log();
    // }
  }
}

class MyNotification {}
