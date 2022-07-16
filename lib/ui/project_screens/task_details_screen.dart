import 'dart:io';

import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/utils/log_extension.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/project_model.dart';
import '../../services/user_service.dart';
import '../../widgets/expandable_text.dart';
import '../../widgets/my_back_button.dart';

class TaskDetailsScreen extends StatelessWidget {
  TaskDetailsScreen({
    Key? key,
    required this.task,
    this.owner,
  }) : super(key: key);
  final ProjectTask task;
  final Organization? owner;
  final userService = Get.find<UserService>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      return ModalProgressHUD(
        inAsyncCall: userService.isBusy.value,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      toolbarHeight: 90,
                      title: SquareButton(
                        icon: Icons.arrow_back_ios_rounded,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          "Task Details,",
                          style: theme.textTheme.headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: kDefaultSpaceVertical),
                    const SliverToBoxAdapter(child: kDefaultSpaceVertical),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title:",
                              style: theme.textTheme.bodyText1,
                            ),
                            kDefaultSpaceVerticalHalf,
                            Text(
                              task.title,
                              style: theme.textTheme.bodyText1,
                            ),
                            if (owner != null) kDefaultSpaceVertical,
                            if (owner != null)
                              Text(
                                "Assigned To: $owner ",
                                style: theme.textTheme.bodyText1,
                              ),
                            kDefaultSpaceVertical,
                            Text(
                              "Description:",
                              style: theme.textTheme.bodyText1,
                            ),
                            kDefaultSpaceVerticalHalf,
                            MyExpandableText(
                              text: task.description,
                              style: theme.textTheme.bodyText2,
                            ),
                            kDefaultSpaceVertical,
                            if (task.isCompleted)
                              Text(
                                "Submitted File:",
                                style: theme.textTheme.bodyText1,
                              ),
                            if (task.isCompleted) kDefaultSpaceVerticalHalf,
                            if (task.isCompleted)
                              Text(
                                "TaskCompleted.zip",
                                style: theme.textTheme.bodyText2?.copyWith(
                                  color: Colors.black54,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: kDefaultPadding,
                child: SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: taskButtonCallBack(context),
                    child: Text(
                      !task.isCompleted
                          ? "Set Task As Completed"
                          : "Download Submitted File",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  VoidCallback? taskButtonCallBack(context) {
    if (!task.isCompleted) {
      if (userService.myOrganizations
          .any((element) => element.id == owner?.id)) {
        return () async {
          final file = await pickFile(context);
          if (file != null) {
            final success = await userService.completeTask(task.id, file.path);
            if (success) {
              userService.loadMyProjects();
              Get.until((route) => Get.currentRoute == '/ProjectsScreen');
            }
          }
        };
      } else {
        return null;
      }
    } else {
      return () {
        if (task.fileUrl != null) {
          downloadFile(task.fileUrl!);
        }
      };
    }
  }

  Future<void> downloadFile(String imageUrl) async {
    Dio dio = Dio();
    PermissionStatus permission1 =
        await Permission.manageExternalStorage.request();
    var status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      permission1 = await Permission.manageExternalStorage.request();
    }
    if (permission1.isGranted) {
      String dirLoc = "";
      if (Platform.isAndroid) {
        dirLoc = "/sdcard/download/";
      } else {
        dirLoc = (await getApplicationDocumentsDirectory()).path;
      }
      try {
        FileUtils.mkdir([dirLoc]);
        await dio.download(
          imageUrl,
          dirLoc + DateTime.now().toString() + basename(imageUrl),
        );
      } catch (e) {
        e.log();
      }
    }
  }

  Future<File?> pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.first.path!);
    } else {
      return null;
    }
  }
}
