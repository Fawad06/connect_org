import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/models/project_model.dart';
import 'package:connect_org/services/cache_service.dart';
import 'package:connect_org/utils/log_extension.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import 'api_service.dart';

class UserService extends GetxService {
  final apiService = Get.find<ApiService>();
  final cacheService = Get.find<CacheService>();
  final Rx<MyUser?> _user = Rx<MyUser?>(null);
  RxBool isBusy = false.obs;

  String newProjectTitle = "";
  DateTime newProjectDateEnded = DateTime.now();
  String newProjectDescription = "";
  RxString selectedMyOrgId = "".obs;
  List<ProjectTask> newProjectTasks = <ProjectTask>[];

  Rx<MyUser?> get user => _user;

  RxList<Organization> myOrganizations = <Organization>[].obs;
  RxList<Project> myProjects = <Project>[].obs;

  updateUser(MyUser user) {
    _user.value = user;
    'Message from UserService: user updated'.log();
  }

  Future getUserFromApi() async {
    try {
      final userEmail = cacheService.loggedInUserEmail();
      final MyUser receivedUser = await apiService.getUser(userEmail);
      _user.value = receivedUser;
      'Message from UserService: user loaded'.log();
    } catch (e) {
      await cacheService.setUserEmail(null);
      "Message from UserService: Error loading user: ${e.toString()}".log();
    }
  }

  Future ensureInitialized() async {
    if (_user.value == null) {
      await getUserFromApi();
    }
  }

  void addLikedOrganization(String organizationId) {
    _user.value!.likedOrganizations.add(organizationId);
  }

  void removeUnLikedOrganization(String organizationId) {
    _user.value!.likedOrganizations.remove(organizationId);
  }

  Future loadMyOrganizations() async {
    try {
      isBusy.value = true;
      final ownerOrgs = await apiService.getOwnerOrganizations(user.value!.id);
      myOrganizations.assignAll(ownerOrgs);
      selectedMyOrgId.value = myOrganizations.first.id;
      'Message from UserService: my orgs loaded'.log();
    } catch (e) {
      "Message from UserService: Error loading my orgs: ${e.toString()}".log();
    } finally {
      isBusy.value = false;
    }
  }

  void clearVariables() {
    newProjectTitle = "";
    newProjectDescription = "";
    selectedMyOrgId.value = "";
    newProjectTasks = <ProjectTask>[];
  }

  Future createProject(organizationId) async {
    try {
      isBusy.value = true;
      await apiService.createProject(
        title: newProjectTitle,
        description: newProjectDescription,
        dateStarted: DateTime.now(),
        dateEnded: newProjectDateEnded,
        senderId: selectedMyOrgId.value,
        receiverId: organizationId,
        tasks: newProjectTasks,
      );
    } catch (e) {
      "Message from UserService: Error creating project: ${e.toString()}".log();
    } finally {
      isBusy.value = false;
    }
  }

  Future loadMyProjects() async {
    try {
      List<Organization> ownerOrgs = [];
      List<Project> allProjects = [];
      isBusy.value = true;
      ownerOrgs = await apiService.getOwnerOrganizations(user.value!.id);
      myOrganizations.assignAll(ownerOrgs);
      for (Organization org in myOrganizations) {
        allProjects.addAll(
          await apiService.getProjects(organizationId: org.id),
        );
      }
      myProjects.assignAll(allProjects);
      'Message from UserService: my projects loaded'.log();
    } catch (e) {
      "Message from UserService: Error loading my projects: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }

  Future editUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String? path,
  ) async {
    try {
      isBusy.value = true;
      await apiService.editUser(
        user.value!.id,
        firstName,
        lastName,
        username,
        email,
        path,
      );
      await getUserFromApi();
    } catch (e) {
      "Message from UserService: Error editing user profile: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }

  Future<bool> completeTask(String taskId, String filePath) async {
    try {
      isBusy.value = true;
      final bool success = await apiService.setTaskAsComplete(
        taskId: taskId,
        filePath: filePath,
      );
      "Message from UserService: task complete:".log();
      return success;
    } catch (e) {
      "Message from UserService: Error editing task: ${e.toString()}".log();
      return false;
    } finally {
      isBusy.value = false;
    }
  }
}
