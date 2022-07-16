import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/controllers/home_controller.dart';
import 'package:connect_org/ui/search_screen/search_screen.dart';
import 'package:connect_org/utils/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../models/job_model.dart';
import '../../utils/constants.dart';
import '../../widgets/my_job_widget.dart';
import '../../widgets/square_avatar.dart';
import 'job_details_screen.dart';

class JobsScreen extends StatelessWidget {
  JobsScreen({Key? key}) : super(key: key);
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final textThemeDark = textTheme.apply(bodyColor: Colors.white).copyWith(
        caption:
            textTheme.caption?.copyWith(color: Colors.white.withOpacity(0.7)));
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: RefreshIndicator(
          onRefresh: homeController.refreshJobData,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Afternoon Fawad",
                    style: textTheme.caption,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Find your\nCreative Job",
                    style: textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Get.to(() => const SearchScreen(autofocus: true)),
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: kContainerShadow,
                              color: theme.colorScheme.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              enabled: false,
                              onTap: () => Get.to(
                                  () => const SearchScreen(autofocus: true)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: theme.colorScheme.background,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Search...",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: kContainerShadow,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () =>
                              Get.to(() => const SearchScreen(autofocus: true)),
                          child: const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "Popular Jobs",
                        style: textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const SearchScreen(
                              showingJobs: true,
                            ),
                          );
                        },
                        child: Text(
                          "Show All",
                          style: textTheme.caption,
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    final jobs = homeController.jobs.toList();
                    return SizedBox(
                      height: 180,
                      child: ListView.separated(
                        itemCount: 3,
                        shrinkWrap: true,
                        key: const PageStorageKey("jobs_list"),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          TextTheme localTextTheme;
                          Color localBackgroundColor;
                          if (index % 2 == 0) {
                            localTextTheme = textThemeDark;
                            localBackgroundColor =
                                theme.colorScheme.onBackground;
                          } else {
                            localTextTheme = textTheme;
                            localBackgroundColor = theme.colorScheme.background;
                          }
                          return MyJobWidget(
                            backgroundColor: localBackgroundColor,
                            textTheme: localTextTheme,
                            width: 270,
                            job: jobs[index],
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 20),
                      ),
                    );
                  }),
                  kDefaultSpaceVertical,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Jobs",
                        style: theme.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const SearchScreen(
                              showingJobs: true,
                            ),
                          );
                        },
                        child: Text(
                          "Show All",
                          style: textTheme.caption,
                        ),
                      ),
                      kDefaultSpaceHorizontalHalf,
                    ],
                  ),
                  kDefaultSpaceVerticalHalf,
                  Obx(
                    () {
                      final jobs = homeController.jobs;
                      final recentJobs = List<Job>.from(jobs);
                      recentJobs.sort(
                        (a, b) => a.dateCreated.compareTo(b.dateCreated),
                      );
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentJobs.isEmpty
                            ? 0
                            : recentJobs.length >= 3
                                ? 3
                                : recentJobs.length,
                        itemBuilder: (context, index) {
                          return Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(20),
                            child: _RecentJobWidget(
                              job: recentJobs.elementAt(index),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => kDefaultSpaceVerticalHalf,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentJobWidget extends StatelessWidget {
  const _RecentJobWidget({
    Key? key,
    required this.job,
  }) : super(key: key);

  final Job job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () => Get.to(
        () => JobDetailsScreen(job: job),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      tileColor: theme.colorScheme.background,
      leading: SquareAvatar(
        colorFilter: ColorFilter.mode(
          theme.textTheme.bodyText1!.color!,
          BlendMode.dstIn,
        ),
        backgroundColor: theme.textTheme.bodyText1!.color,
        backgroundImage: CachedNetworkImageProvider(job.imageUrl),
      ),
      title: Text(
        job.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: SizedBox(
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "${job.organization.name}  - ${job.isFullTime ? "Full Time" : "Part Time"}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.caption,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                job.dueDate.getStringTime(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
