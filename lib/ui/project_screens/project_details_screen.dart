import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/ui/project_screens/task_details_screen.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/utils/log_extension.dart';
import 'package:connect_org/widgets/expandable_text.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/organization_model.dart';
import '../../models/project_model.dart';
import '../../widgets/my_radial_gauge.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;
  const ProjectDetailsScreen({Key? key, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kDefaultSpaceVertical,
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: kContainerShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: theme.textTheme.headline6,
                            ),
                            kDefaultSpaceVerticalHalf,
                            MyExpandableText(
                              style: theme.textTheme.bodyText2,
                              text: project.description,
                            ),
                            kDefaultSpaceVerticalHalf,
                            Text(
                              'Starting Date: ${project.dateStarted.day}/${project.dateStarted.month}/${project.dateStarted.year}',
                              style: theme.textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                      kDefaultSpaceHorizontalHalf,
                      MyPercentIndicator(
                        height: 100,
                        width: 100,
                        percent: (project.tasks
                                .where((element) => element.isCompleted)
                                .length /
                            project.tasks.length),
                        bottomChild: Text(
                          'Progress',
                          style: theme.textTheme.bodyText1,
                        ),
                        centerChild: Text(
                          '${((project.tasks.where((element) => element.isCompleted).length / project.tasks.length) * 100).toInt()} %',
                          style: theme.textTheme.headline6,
                        ),
                      )
                    ],
                  ),
                ),
                kDefaultSpaceVertical,
                Text(
                  "Collaborators: ",
                  style: theme.textTheme.headline6,
                ),
                kDefaultSpaceVertical,
                Text("From:", style: theme.textTheme.bodyText1),
                buildOrganizationTile(
                  context,
                  organization: project.senderId == project.collaborator1.id
                      ? project.collaborator1
                      : project.collaborator2,
                ),
                kDefaultSpaceVerticalHalf,
                Text("To:", style: theme.textTheme.bodyText1),
                buildOrganizationTile(
                  context,
                  organization: project.receiverId == project.collaborator1.id
                      ? project.collaborator1
                      : project.collaborator2,
                ),
                kDefaultSpaceVertical,
                Text(
                  "Tasks: ",
                  style: theme.textTheme.headline6,
                ),
                kDefaultSpaceVertical,
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: project.tasks.length,
                  itemBuilder: (_, index) {
                    final task = project.tasks[index];
                    final Organization taskOwner =
                        project.collaborator1.id == task.ownerId
                            ? project.collaborator1
                            : project.collaborator2;
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => TaskDetailsScreen(
                            task: task,
                            owner: taskOwner,
                          ),
                        );
                      },
                      child: Material(
                        color: theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: theme.textTheme.bodyText1,
                                    ),
                                    kDefaultSpaceVerticalHalf,
                                    Text(
                                      task.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.caption,
                                    ),
                                    kDefaultSpaceVerticalHalf,
                                    Text(
                                      "Assigned To: ${taskOwner.name}",
                                      style: theme.textTheme.caption,
                                    ),
                                    kDefaultSpaceVerticalHalf,
                                    if (task.isCompleted)
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.3),
                                        ),
                                        onPressed: () {
                                          if (task.fileUrl != null) {
                                            downloadFile(task.fileUrl!);
                                          }
                                        },
                                        child: Text(
                                          "Download File",
                                          style: theme.textTheme.bodyText1,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                activeColor: Colors.green,
                                value: task.isCompleted,
                                shape: const CircleBorder(),
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => kDefaultSpaceVerticalHalf,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Material buildOrganizationTile(
    BuildContext context, {
    required Organization organization,
    bool showArrow = false,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.background,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.onBackground,
          ),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              organization.imageUrl,
            ),
          ),
        ),
        title: Text(
          organization.name,
          style: theme.textTheme.bodyText1,
        ),
        subtitle: Text(
          organization.address,
          style: theme.textTheme.caption,
        ),
        trailing: showArrow ? const Icon(Icons.arrow_drop_down) : null,
      ),
    );
  }
}
