import 'package:connect_org/controllers/home_controller.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/utils/log_extension.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/user_service.dart';

class OrganizationsController extends GetxController {
  final apiService = Get.find<ApiService>();
  final userService = Get.find<UserService>();
  RxBool isBusy = false.obs;
  String newName = "";
  String newEmail = "";
  String newNTN = "";
  String newDescription = "";
  String newLocation = "";
  String newImagePath = "";
  RxBool newWorkStatus = false.obs;
  Rx<OrganizationDetails> orgDetails = Rx<OrganizationDetails>(
    OrganizationDetails(
      chatId: "",
      reviews: <Review>[],
      services: <OrganizationService>[],
      organization: Organization(
        id: "",
        ownerId: "",
        name: "name",
        email: "",
        description: "",
        address: "",
        nationalTaxNumber: "",
        imageUrl:
            "https://thumbs.dreamstime.com/z/organization-word-cloud-business-concept-58626767.jpg",
        workStatus: false,
        isVerified: false,
        isApproved: true,
        dateCreated: DateTime.now(),
        likes: 12,
      ),
    ),
  );

  Future loadOrganizationDetails(Organization organization) async {
    try {
      isBusy.value = true;
      final orgDetails = await apiService.getOrganizationDetails(
        organization.id,
        userService.user.value!.id,
      );
      this.orgDetails.value = orgDetails;
    } catch (e) {
      "Message from OrganizationsController: Error loading organization details: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }

  Future editOrganizationDetails(String organizationId) async {
    try {
      isBusy.value = true;
      await apiService.editOrganizationDetails(
        organizationId: organizationId,
        name: newName,
        address: newLocation,
        description: newDescription,
      );
      await apiService.setOrganizationWorkStatus(
        setWorkStatusAsOpen: newWorkStatus.value,
        organizationId: organizationId,
      );
      final org = await apiService.updateOrganizationPicture(
        organizationId: organizationId,
        filePath: newImagePath,
      );
      final index = Get.find<HomeController>().organizations.indexWhere(
            (p0) => p0.id == organizationId,
          );
      Get.find<HomeController>().organizations.insert(index, org);
    } catch (e) {
      "Message from OrganizationsController: Error loading organization details: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }

  void clearVariables() {
    isBusy = false.obs;
    newName = "";
    newEmail = "";
    newNTN = "";
    newDescription = "";
    newLocation = "";
    newImagePath = "";
    newWorkStatus = false.obs;
  }

  Future reportOrganization(String reportReason) async {
    try {
      await apiService.reportOrganization(
        userService.user.value!.id,
        orgDetails.value.organization.id,
        reportReason,
      );
    } catch (e) {
      "Message from OrganizationsController: Error loading organization details: ${e.toString()}"
          .log();
    }
  }

  Future createOrganization(String? filePath) async {
    try {
      isBusy.value = true;
      Organization? organization;
      final org = await apiService.createOrganization(
        userService.user.value!.id,
        newName,
        newDescription,
        newLocation,
        newEmail,
        newNTN,
      );
      if (filePath != null) {
        organization = await apiService.updateOrganizationPicture(
            organizationId: org.id, filePath: filePath);
      }
      Get.find<HomeController>().organizations.add(organization!);
    } catch (e) {
      "Message from OrganizationsController: Error loading organization details: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }
}
