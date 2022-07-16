import 'package:connect_org/controllers/jobs_controller.dart';
import 'package:connect_org/controllers/organizations_controller.dart';
import 'package:connect_org/utils/date_time_extension.dart';
import 'package:connect_org/widgets/square_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/job_model.dart';
import '../ui/job_screens/job_details_screen.dart';
import '../ui/organizations_screens/organization_details.dart';
import '../utils/constants.dart';

class MyJobWidget extends StatelessWidget {
  const MyJobWidget({
    Key? key,
    this.backgroundColor = Colors.white,
    this.textTheme,
    required this.job,
    this.showToggle = false,
    this.width = double.maxFinite,
    this.height = 180,
  }) : super(key: key);

  final Color backgroundColor;
  final TextTheme? textTheme;
  final Job job;
  final bool showToggle;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textTheme = this.textTheme ?? Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Get.to(
        () => JobDetailsScreen(
          job: job,
          showEdit: showToggle,
        ),
      ),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
          boxShadow: kContainerShadow,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 1,
                      style: textTheme.headline6?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          job.getPay,
                          style: textTheme.caption,
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
                            job.isFullTime ? "Full Time" : "Part Time",
                            style: textTheme.caption,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                if (showToggle) buildSwitch(),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
            ListTile(
              onTap: () {
                Get.find<OrganizationsController>().loadOrganizationDetails(
                  job.organization,
                );
                Get.to(() => const OrganizationDetailsScreen());
              },
              contentPadding: EdgeInsets.zero,
              leading: SquareAvatar(
                colorFilter: ColorFilter.mode(
                  textTheme.bodyText1!.color!,
                  BlendMode.dstIn,
                ),
                backgroundColor: textTheme.bodyText1!.color,
                backgroundImage: NetworkImage(job.organization.imageUrl),
              ),
              title: Text(
                job.organization.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyText1,
              ),
              subtitle: SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        job.organization.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.caption,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "${job.dueDate.getStringTime()} left",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.caption?.copyWith(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitch() {
    bool isActive = job.isActive ?? true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Switch(
          value: isActive,
          onChanged: (value) {
            setState(() {
              isActive = value;
            });
            Get.find<JobsController>().setJobStatus(value, job.id);
          },
        );
      },
    );
  }
}
