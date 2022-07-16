import 'package:connect_org/controllers/jobs_controller.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/ui/job_screens/add_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../utils/constants.dart';
import '../../widgets/my_back_button.dart';
import '../../widgets/my_job_widget.dart';

class AllJobsScreen extends StatelessWidget {
  final bool showAddJobButton;

  final Organization organization;

  AllJobsScreen({
    Key? key,
    this.showAddJobButton = false,
    required this.organization,
  }) : super(key: key);
  final controller = Get.find<JobsController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          if (controller.organizationJobs.isNotEmpty) {
            return controller.loadOrganizationJobs(
              controller.organizationJobs.first.organization.id,
            );
          } else {
            return Future(() {});
          }
        },
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
                  "All Available Jobs,",
                  style: theme.textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (showAddJobButton)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: SizedBox(
                    height: 60,
                    width: double.maxFinite,
                    child: Material(
                      elevation: 1,
                      color: theme.colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Get.find<JobsController>().clearVariables();
                          Get.to(
                            () => AddJobScreen(
                              organization: organization,
                            ),
                          );
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
              sliver: Obx(() {
                final jobs = controller.organizationJobs.toList();
                final activeJob = showAddJobButton
                    ? jobs
                    : jobs
                        .where((element) => element.isActive ?? true)
                        .toList();
                if (controller.isBusy.value) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (activeJob.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Assets.imagesBox),
                          Text(
                            "No job found!",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: activeJob.length,
                    (context, index) {
                      return MyJobWidget(
                        job: activeJob.elementAt(index),
                        showToggle: showAddJobButton,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
