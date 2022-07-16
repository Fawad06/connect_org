import 'package:connect_org/ui/application_screen/application_screen.dart';
import 'package:connect_org/ui/job_screens/jobs_screen.dart';
import 'package:connect_org/ui/organizations_screens/my_organizations.dart';
import 'package:connect_org/ui/project_screens/projects_screen.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../widgets/my_radial_gauge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 90,
            title: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: theme.iconTheme.color,
                ),
                kDefaultSpaceHorizontalHalf,
                Text(
                  "Dashboard",
                  style: theme.textTheme.headline6,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Stats",
                    style: theme.textTheme.headline6,
                  ),
                  kDefaultSpaceVerticalHalf,
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => MyOrganizationsScreen());
                          },
                          child: Container(
                            height: 150,
                            padding: kDefaultPadding,
                            decoration:
                                kContainerCardDecoration(context).copyWith(
                              color: Colors.lightBlueAccent.shade100,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Organizations",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      const Shadow(
                                        color: Colors.grey,
                                        blurRadius: 4,
                                        offset: Offset(-2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                kDefaultSpaceVerticalHalf,
                                Text(
                                  "Approved",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyText2?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      kTextShadowGrey,
                                    ],
                                  ),
                                ),
                                Text(
                                  "3",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  "Total",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyText2?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      kTextShadowGrey,
                                    ],
                                  ),
                                ),
                                Text(
                                  "5",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      kDefaultSpaceHorizontalHalf,
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const ProjectsScreen());
                          },
                          child: Container(
                            height: 150,
                            padding: kDefaultPadding,
                            decoration:
                                kContainerCardDecoration(context).copyWith(
                              color: Colors.tealAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Projects",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.headline6?.copyWith(
                                        color: Colors.white,
                                        shadows: [
                                          kTextShadowGrey,
                                        ],
                                      ),
                                    ),
                                    kDefaultSpaceVerticalHalf,
                                    Text(
                                      "In Progress",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.bodyText2?.copyWith(
                                        color: Colors.white,
                                        shadows: [
                                          kTextShadowGrey,
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "3",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.headline6?.copyWith(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                    Text(
                                      "Completed",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.bodyText2?.copyWith(
                                        color: Colors.white,
                                        shadows: [
                                          kTextShadowGrey,
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "1",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.headline6?.copyWith(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                MyPercentIndicator(
                                  height: 40,
                                  width: 40,
                                  centerChild: Text(
                                    '70%',
                                    style: theme.textTheme.bodyText1?.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                  percent: 0.7,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  kDefaultSpaceVerticalHalf,
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => JobsScreen());
                          },
                          child: Container(
                            height: 150,
                            padding: kDefaultPadding,
                            decoration:
                                kContainerCardDecoration(context).copyWith(
                              color: Colors.orangeAccent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Jobs",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.headline6?.copyWith(
                                        color: Colors.white,
                                        shadows: [
                                          const Shadow(
                                            color: Colors.grey,
                                            blurRadius: 4,
                                            offset: Offset(-2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.chartLine,
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ],
                                ),
                                kDefaultSpaceVerticalHalf,
                                Text(
                                  "Job Opened",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyText2?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      kTextShadowGrey,
                                    ],
                                  ),
                                ),
                                Text(
                                  "7",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  "Closed",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyText2?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      kTextShadowGrey,
                                    ],
                                  ),
                                ),
                                Text(
                                  "3",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      kDefaultSpaceHorizontalHalf,
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const ApplicationsScreen());
                          },
                          child: Container(
                            height: 150,
                            padding: kDefaultPadding,
                            decoration:
                                kContainerCardDecoration(context).copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Application",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      kTextShadowGrey,
                                    ],
                                  ),
                                ),
                                kDefaultSpaceVerticalHalf,
                                Text(
                                  "Received",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyText2?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      kTextShadowGrey,
                                    ],
                                  ),
                                ),
                                Text(
                                  "3",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: theme.colorScheme.tertiary,
                                  ),
                                ),
                                Text(
                                  "Approved",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyText2?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      kTextShadowGrey,
                                    ],
                                  ),
                                ),
                                Text(
                                  "1",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: theme.colorScheme.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  kDefaultSpaceVertical,
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: MyClipper2(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.maxFinite,
                          ),
                        ),
                        ClipPath(
                          clipper: MyClipper(),
                          child: Container(
                            padding: kDefaultPadding,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Organizations Popularity",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    shadows: [kTextShadowGrey],
                                  ),
                                ),
                                kDefaultSpaceVerticalHalf,
                                Text(
                                  "Likes: 123,322",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyText1?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Comments: 1,213",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyText1?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kDefaultSpaceVertical,
                  Text(
                    "Recent Project",
                    style: theme.textTheme.headline6,
                  ),
                  kDefaultSpaceVerticalHalf,
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.to(() => ProjectDetailsScreen(project: project1));
                  //   },
                  //   child: Container(
                  //     height: 180,
                  //     padding: const EdgeInsets.all(20),
                  //     decoration: BoxDecoration(
                  //       color: theme.colorScheme.background,
                  //       borderRadius: BorderRadius.circular(20),
                  //       boxShadow: kContainerShadow,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 project1.title,
                  //                 style: theme.textTheme.headline6,
                  //               ),
                  //               kDefaultSpaceVerticalHalf,
                  //               Text(
                  //                 project1.description,
                  //                 style: theme.textTheme.bodyText2,
                  //               ),
                  //               kDefaultSpaceVerticalHalf,
                  //               Text(
                  //                 'Starting Date: ${project1.dateStarted.day}/${project1.dateStarted.month}/${project1.dateStarted.year}',
                  //                 style: theme.textTheme.bodyText2,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         kDefaultSpaceHorizontalHalf,
                  //         MyPercentIndicator(
                  //           height: 120,
                  //           percent: 0.7,
                  //           centerChild: Text(
                  //             '${(project1.progressPercentage * 100).toInt()} %',
                  //             style: theme.textTheme.headline6,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.8 - 5, 0.0)
      ..arcToPoint(Offset(size.width * 0.8, 5.0),
          radius: const Radius.circular(5))
      ..lineTo((size.width) * 0.8, 5)
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height / 2,
        size.width * 0.65,
        size.height / 2,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height / 2,
        size.width * 0.5,
        size.height - 5,
      )
      ..arcToPoint(
        Offset(size.width * 0.5 - 5, size.height),
        radius: const Radius.circular(5),
      )
      ..lineTo(0, size.height)
      ..lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.85 - 5, 0.0)
      ..arcToPoint(Offset(size.width * 0.85, 5.0),
          radius: const Radius.circular(5))
      ..lineTo((size.width) * 0.85, 5)
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height / 2,
        size.width * 0.65,
        size.height / 2,
      )
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height / 2,
        size.width * 0.55,
        size.height - 5,
      )
      ..arcToPoint(
        Offset(size.width * 0.55 - 5, size.height),
        radius: const Radius.circular(5),
      )
      ..lineTo(0, size.height)
      ..lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
