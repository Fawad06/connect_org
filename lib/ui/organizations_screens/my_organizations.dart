import 'package:connect_org/controllers/jobs_controller.dart';
import 'package:connect_org/controllers/organizations_controller.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/ui/organizations_screens/organization_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../utils/constants.dart';
import '../../widgets/my_back_button.dart';
import '../job_screens/all_jobs_screen.dart';
import 'add_organization_screen.dart';

class MyOrganizationsScreen extends StatelessWidget {
  MyOrganizationsScreen({Key? key}) : super(key: key);

  final userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: userService.isBusy.value,
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
                    "Organizations Owned,",
                    style: theme.textTheme.headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: kDefaultPadding,
                  child: SizedBox(
                    height: 60,
                    width: double.maxFinite,
                    child: Material(
                      elevation: 1,
                      color: theme.colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Get.find<OrganizationsController>().clearVariables();
                          Get.to(() => AddOrganizationScreen());
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: kDefaultPadding,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: userService.myOrganizations.length,
                    (context, index) {
                      final organization = userService.myOrganizations[index];
                      return MyOrganizationWidget(organization: organization);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class MyOrganizationWidget extends StatelessWidget {
  const MyOrganizationWidget({
    Key? key,
    required this.organization,
  }) : super(key: key);

  final Organization organization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 200,
      width: double.maxFinite,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.find<OrganizationsController>().loadOrganizationDetails(
                organization,
              );
              Get.to(() {
                return const OrganizationDetailsScreen(showEditButton: true);
              });
            },
            child: Container(
              height: 170,
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              margin: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.colorScheme.background,
                boxShadow: kContainerShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organization.name,
                        maxLines: 1,
                        style: theme.textTheme.headline6?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.find<UserService>()
                              .myOrganizations
                              .removeWhere((element) {
                            return element.id == organization.id;
                          });
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        organization.address,
                        style: theme.textTheme.caption,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          organization.workStatus
                              ? "Open to Work"
                              : "Closed to Work",
                          style: theme.textTheme.caption,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Total Likes: ${organization.likes}",
                        style: theme.textTheme.caption,
                      ),
                      const SizedBox(width: 10),
                      // Text(
                      //   "Total services: 123",
                      //   style: theme.textTheme.caption,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Rating: ",
                        style: theme.textTheme.caption,
                      ),
                      const SizedBox(width: 10),
                      // ...List.generate(
                      //   5,
                      //   (index) => index + 1 <= organization.rating.floor()
                      //       ? const Icon(
                      //           Icons.star,
                      //           color: Colors.yellow,
                      //         )
                      //       : Icon(
                      //           Icons.star_border_outlined,
                      //           color: theme.colorScheme.onBackground,
                      //         ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Verified: ",
                            style: theme.textTheme.caption,
                          ),
                          const SizedBox(width: 10),
                          organization.isVerified
                              ? const Icon(
                                  Icons.verified_rounded,
                                  color: Colors.green,
                                  size: 20,
                                )
                              : const Icon(
                                  Icons.block,
                                  color: Colors.red,
                                  size: 20,
                                ),
                        ],
                      ),
                      Text(
                        "NTN: ${organization.nationalTaxNumber}",
                        style: theme.textTheme.caption,
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
          ),
          Positioned(
            top: 160,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Get.find<JobsController>().loadOrganizationJobs(
                  organization.id,
                );
                Get.to(
                  () => AllJobsScreen(
                    organization: organization,
                    showAddJobButton: true,
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: kContainerShadow,
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                  ),
                ),
                child: Text(
                  "View Jobs",
                  style: theme.textTheme.bodyText1?.copyWith(
                    shadows: [
                      const Shadow(
                        color: Colors.red,
                        blurRadius: 3,
                        offset: Offset(-1, 2),
                      ),
                    ],
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
