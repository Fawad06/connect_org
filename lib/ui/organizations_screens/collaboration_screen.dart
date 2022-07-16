import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/widgets/my_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/project_model.dart';
import '../../utils/validators.dart';
import '../project_screens/task_details_screen.dart';

class CollaborationScreen extends StatefulWidget {
  final Organization organization;

  const CollaborationScreen({Key? key, required this.organization})
      : super(key: key);

  @override
  State<CollaborationScreen> createState() => _CollaborationScreenState();
}

class _CollaborationScreenState extends State<CollaborationScreen> {
  final _formKey = GlobalKey<FormState>();
  final userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              if (userService.isBusy.value)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (!userService.isBusy.value)
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: 90,
                        floating: true,
                        title: SquareButton(
                          onPressed: () => Get.back(),
                          icon: Icons.arrow_back_ios_rounded,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: kDefaultPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Collaboration Details,",
                                  style: theme.textTheme.headline5?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                kDefaultSpaceVertical,
                                Text(
                                  "Organizations:",
                                  style: theme.textTheme.headline6,
                                ),
                                kDefaultSpaceVertical,
                                Text("From:", style: theme.textTheme.bodyText1),
                                if (userService.myOrganizations.isNotEmpty)
                                  buildPopupMenuButton(),
                                kDefaultSpaceVerticalHalf,
                                Text("To:", style: theme.textTheme.bodyText1),
                                buildOrganizationTile(
                                  organization: widget.organization,
                                ),
                                kDefaultSpaceVertical,
                                Text(
                                  "Project Title:",
                                  style: theme.textTheme.headline6,
                                ),
                                kDefaultSpaceVerticalHalf,
                                Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(10),
                                  child: TextField(
                                    onChanged: (value) {
                                      userService.newProjectTitle = value;
                                    },
                                    decoration: kTextFormFieldDecoration(
                                      theme.colorScheme.background,
                                      null,
                                      "Connect Org, Bubble Shooter etc.",
                                    ),
                                  ),
                                ),
                                kDefaultSpaceVertical,
                                Text(
                                  "Description:",
                                  style: theme.textTheme.headline6,
                                ),
                                kDefaultSpaceVerticalHalf,
                                SizedBox(
                                  height: 150,
                                  child: Material(
                                    elevation: 1,
                                    borderRadius: BorderRadius.circular(10),
                                    child: TextField(
                                      minLines: null,
                                      maxLines: null,
                                      expands: true,
                                      onChanged: (value) {
                                        userService.newProjectDescription =
                                            value;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      textAlignVertical: TextAlignVertical.top,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        hintText: "Description...",
                                        filled: true,
                                        fillColor: theme.colorScheme.background,
                                      ),
                                    ),
                                  ),
                                ),
                                kDefaultSpaceVertical,
                                Text(
                                  "Add Project Tasks:",
                                  style: theme.textTheme.headline6,
                                ),
                                kDefaultSpaceVerticalHalf,
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: userService.newProjectTasks.length,
                                  itemBuilder: (context, index) {
                                    final task =
                                        userService.newProjectTasks[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => TaskDetailsScreen(task: task),
                                        );
                                      },
                                      child: buildTaskTile(theme, task),
                                    );
                                  },
                                  separatorBuilder: (_, __) =>
                                      kDefaultSpaceVerticalHalf,
                                ),
                                kDefaultSpaceVerticalHalf,
                                GestureDetector(
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return buildAlertDialog(theme, context,
                                            widget.organization.id);
                                      },
                                    );
                                    setState(() {});
                                  },
                                  child: SizedBox(
                                    height: 60,
                                    width: double.maxFinite,
                                    child: Material(
                                      elevation: 1,
                                      color: theme.colorScheme.background,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                kDefaultSpaceVerticalHalf,
                                Text(
                                  "Ending Date (Estimated):",
                                  style: theme.textTheme.headline6,
                                ),
                                kDefaultSpaceVerticalHalf,
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userService.newProjectDateEnded
                                            .toString(),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2015, 8),
                                          lastDate: DateTime(2101),
                                        );
                                        if (picked != null) {
                                          userService.newProjectDateEnded =
                                              picked;
                                          setState(() {});
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.calendar_today_outlined),
                                    ),
                                  ],
                                ),
                                kDefaultSpaceVertical,
                              ],
                            ),
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
                    onPressed: () async {
                      await userService.createProject(widget.organization.id);
                      Get.back();
                    },
                    child: const Text("Send Project Request"),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  SizedBox buildTaskTile(ThemeData theme, ProjectTask task) {
    return SizedBox(
      height: 60,
      width: double.maxFinite,
      child: Material(
        elevation: 1,
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                task.title,
                style: theme.textTheme.bodyText1,
              ),
              Text(
                task.description,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton() {
    return PopupMenuButton<String>(
      child: buildOrganizationTile(
        organization: userService.myOrganizations.firstWhere(
            (element) => element.id == userService.selectedMyOrgId.value),
        showArrow: true,
      ),
      onSelected: (value) {
        userService.selectedMyOrgId.value = value;
      },
      itemBuilder: (context) {
        return userService.myOrganizations
            .map((element) => PopupMenuItem<String>(
                  value: element.id,
                  child: buildOrganizationTile(
                    organization: element,
                  ),
                ))
            .toList();
      },
    );
  }

  Material buildOrganizationTile({
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
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            organization.imageUrl,
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

  AlertDialog buildAlertDialog(
      ThemeData theme, BuildContext context, String organizationId) {
    String taskTitle = "";
    String taskDescription = "";
    final _formKey = GlobalKey<FormState>();
    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(
        "Add New Task",
        style: theme.textTheme.bodyText1,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Name:",
              style: theme.textTheme.bodyText1,
            ),
            kDefaultSpaceVerticalHalf,
            Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                onChanged: (value) {
                  taskTitle = value;
                },
                validator: Validators.nameValidator,
                decoration: kTextFormFieldDecoration(
                  theme.colorScheme.background,
                  null,
                  "Task1, Task2...",
                ),
              ),
            ),
            kDefaultSpaceVertical,
            Text(
              "Description:",
              style: theme.textTheme.bodyText1,
            ),
            kDefaultSpaceVerticalHalf,
            SizedBox(
              height: 150,
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(10),
                child: TextFormField(
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  onChanged: (value) {
                    taskDescription = value;
                  },
                  validator: Validators.nameValidator,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: kTextFormFieldDecoration(
                    theme.colorScheme.background,
                    null,
                    "Description...",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: 90,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                userService.newProjectTasks.add(
                  ProjectTask(
                    title: taskTitle,
                    isCompleted: false,
                    id: 'abc',
                    description: taskDescription,
                    ownerId: Random().nextInt(2) == 0
                        ? userService.myOrganizations[0].id
                        : organizationId,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Confirm"),
          ),
        ),
        SizedBox(
          width: 90,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ),
      ],
    );
  }
}
