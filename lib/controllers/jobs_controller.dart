import 'package:connect_org/utils/log_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../models/job_model.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';

class JobsController extends GetxController {
  final apiService = Get.find<ApiService>();
  final userService = Get.find<UserService>();

  RxBool isBusy = false.obs;
  RxList<Job> organizationJobs = <Job>[].obs;
  String newJobTitle = "";
  String newJobDescription = "";
  String newJobMinPay = "";
  String newJobMaxPay = "";
  RxBool newJobIsFullTime = true.obs;
  Rx<DateTime> newJobDueDate = Rx<DateTime>(
    DateTime.utc(DateTime.now().year, DateTime.now().month + 1),
  );

  Future loadOrganizationJobs(String organizationId) async {
    try {
      isBusy.value = true;
      organizationJobs.clear();
      final orgJobs = await apiService.getOrganizationJobs(
        organizationId,
      );
      organizationJobs.assignAll(orgJobs);
    } catch (e) {
      "Message from JobsController: Error loading organization jobs: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }

  Future setJobStatus(bool value, jobId) async {
    try {
      if (value) {
        final job = await apiService.setJobAsActive(jobId);
        final setActiveJobIndex = organizationJobs.indexWhere(
          (element) => element.id == jobId,
        );
        organizationJobs[setActiveJobIndex] = job;
      } else {
        final job = await apiService.setJobAsNotActive(jobId);
        final setNotActiveJobIndex = organizationJobs.indexWhere(
          (element) => element.id == jobId,
        );
        organizationJobs[setNotActiveJobIndex] = job;
      }
    } catch (e) {
      "Message from JobsController: Error loading organization jobs: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }

  Future sendJobApplication(String jobId, cvFilePath) async {
    try {
      isBusy.value = true;
      await apiService.applyForJob(
        userService.user.value!.id,
        jobId,
        cvFilePath,
      );
      Fluttertoast.showToast(
        msg: "Application Sent",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      "Message from JobsController: Error loading organization jobs: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }

  Future createJob(String? filePath, String organizationId) async {
    try {
      isBusy.value = true;
      final jobWithoutPic = await apiService.createJob(
        title: newJobTitle,
        description: newJobDescription,
        minSalary: newJobMinPay,
        maxSalary: newJobMaxPay,
        orgId: organizationId,
        isFullTime: newJobIsFullTime.value,
        dateDue: newJobDueDate.value,
      );
      if (filePath != null) {
        await apiService.updateJobImage(
          jobId: jobWithoutPic.id,
          filePath: filePath,
        );
      }
    } catch (e) {
      "Message from JobsController: Error creating job: ${e.toString()}".log();
    } finally {
      isBusy.value = false;
    }
  }

  void clearVariables() {
    isBusy = false.obs;
    newJobTitle = "";
    newJobDescription = "";
    newJobMinPay = "";
    newJobMaxPay = "";
    newJobIsFullTime.value = true;
  }
}
