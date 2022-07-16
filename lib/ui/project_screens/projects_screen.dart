import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/models/project_model.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/ui/project_screens/project_details_screen.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/widgets/filled_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../generated/assets.dart';
import '../../widgets/my_back_button.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int selectedIndex = 0;
  final userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        title: SquareButton(
          icon: Icons.arrow_back_ios_rounded,
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "My ",
                  style: theme.textTheme.headline6,
                  children: [
                    TextSpan(
                      text: "Projects",
                      style: theme.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              kDefaultSpaceVerticalHalf,
              Row(
                children: [
                  FilledOutlineButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    text: "All Projects",
                    isFilled: selectedIndex == 0 ? true : false,
                  ),
                  kDefaultSpaceHorizontalHalf,
                  FilledOutlineButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    text: "In Progress",
                    isFilled: selectedIndex == 1 ? true : false,
                  ),
                  kDefaultSpaceHorizontalHalf,
                  FilledOutlineButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    text: "Completed",
                    isFilled: selectedIndex == 2 ? true : false,
                  ),
                ],
              ),
              kDefaultSpaceVertical,
              Expanded(
                child: Obx(() {
                  final projects = userService.myProjects.toList();
                  if (userService.isBusy.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (selectedIndex == 0) {
                    return buildProjectsList(projects, context);
                  } else if (selectedIndex == 1) {
                    final projectsInProgress = projects
                        .where((project) => project.tasks.any(
                              (task) => !task.isCompleted,
                            ))
                        .toList();
                    return buildProjectsList(projectsInProgress, context);
                  } else {
                    final projectsCompleted = projects
                        .where((project) => !project.tasks.any(
                              (task) => !task.isCompleted,
                            ))
                        .toList();
                    return buildProjectsList(projectsCompleted, context);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProjectsList(List<Project> projects, BuildContext context) {
    if (projects.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.imagesBox),
            Text(
              "No projects found!",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: projects.length,
      itemBuilder: (_, index) {
        final project = projects.elementAt(index);
        return ProjectCardWidget(
          project: project,
          onPressed: () {
            Get.to(() => ProjectDetailsScreen(project: project));
          },
        );
      },
      separatorBuilder: (_, __) => kDefaultSpaceVerticalHalf,
    );
  }
}

class ProjectCardWidget extends StatelessWidget {
  const ProjectCardWidget({
    Key? key,
    required this.project,
    required this.onPressed,
  }) : super(key: key);

  final Project project;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: kContainerShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  project.title,
                  style: theme.textTheme.bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  " - ${project.description}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyText2,
                ),
              ],
            ),
            kDefaultSpaceVerticalHalf,
            Row(
              children: [
                Text(
                  "Collaborators: ",
                  style: theme.textTheme.bodyText1,
                ),
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 45,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.onBackground,
                        ),
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            project.collaborator1.imageUrl,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onBackground,
                      ),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          project.collaborator2.imageUrl,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            kDefaultSpaceVerticalHalf,
            Text(
              "Tasks done: ${project.tasks.where((element) => element.isCompleted).length}/${project.tasks.length}",
              style: theme.textTheme.caption?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            kDefaultSpaceVertical,
            Row(
              children: [
                Expanded(
                  child: LinearPercentIndicator(
                    percent: (project.tasks
                            .where((element) => element.isCompleted)
                            .length /
                        project.tasks.length),
                    lineHeight: 7,
                    padding: const EdgeInsets.only(right: 10),
                    barRadius: const Radius.circular(20),
                    progressColor: theme.primaryColor,
                    backgroundColor: theme.primaryColor.withOpacity(
                      0.1,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "${((project.tasks.where((element) => element.isCompleted).length / project.tasks.length) * 100).toInt()}%",
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
