import 'package:connect_org/controllers/home_controller.dart';
import 'package:connect_org/models/job_model.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/organizations_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/my_back_button.dart';
import '../../widgets/my_job_widget.dart';
import '../../widgets/my_organization_widget.dart';
import '../organizations_screens/organization_details.dart';

class SearchScreen extends StatefulWidget {
  final bool autofocus;

  final bool showingJobs;

  const SearchScreen({
    Key? key,
    this.autofocus = false,
    this.showingJobs = false,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Obx(() {
        List<Organization> orgs = [];
        List<Job> jobs = [];
        if (widget.showingJobs) {
          jobs = controller.jobs.toList();
        } else {
          orgs = controller.organizations.toList();
        }
        return RefreshIndicator(
          onRefresh: widget.showingJobs
              ? controller.refreshJobData
              : controller.refreshOrgData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                toolbarHeight: 190,
                backgroundColor: theme.scaffoldBackgroundColor,
                title: buildAppBar(theme),
              ),
              SliverPadding(
                padding: kDefaultPadding,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: widget.showingJobs ? jobs.length : orgs.length,
                    (context, index) {
                      if (widget.showingJobs) {
                        return MyJobWidget(job: jobs[index]);
                      } else {
                        return OrganizationWidget(
                          organization: orgs[index],
                          onPressed: () {
                            Get.find<OrganizationsController>()
                                .loadOrganizationDetails(orgs[index]);
                            Get.to(() => const OrganizationDetailsScreen());
                          },
                          onLikePressed: (isLiked) {
                            controller.likeUnLikeOrganization(
                              isLiked,
                              orgs[index].id,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Container buildAppBar(ThemeData theme) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SquareButton(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: () => Get.back(),
          ),
          kDefaultSpaceVertical,
          Text(
            "All ${widget.showingJobs ? "Jobs" : "Organization"},",
            style: theme.textTheme.headline5,
          ),
          kDefaultSpaceVerticalHalf,
          Hero(
            tag: "searchtextfield",
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: kContainerShadow,
                      color: theme.colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      autofocus: widget.autofocus,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.colorScheme.background,
                        contentPadding: kDefaultPadding,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Search...",
                      ),
                    ),
                  ),
                ),
                kDefaultSpaceHorizontal,
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: kContainerShadow,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: const Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                kDefaultSpaceHorizontal,
              ],
            ),
          ),
          kDefaultSpaceVertical,
        ],
      ),
    );
  }
}
