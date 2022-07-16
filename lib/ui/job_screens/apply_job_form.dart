import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/controllers/jobs_controller.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/widgets/expandable_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../../models/job_model.dart';
import '../../widgets/my_back_button.dart';
import '../organizations_screens/organization_details.dart';

class JobApplicationForm extends StatefulWidget {
  final Job job;

  const JobApplicationForm({Key? key, required this.job}) : super(key: key);

  @override
  State<JobApplicationForm> createState() => _JobApplicationFormState();
}

class _JobApplicationFormState extends State<JobApplicationForm> {
  File? cv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                      child: Padding(
                        padding: kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apply for Job,",
                              style: theme.textTheme.headline5
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            kDefaultSpaceVertical,
                            RichText(
                              text: TextSpan(
                                  text: "Title: ",
                                  style: theme.textTheme.bodyText1,
                                  children: [
                                    TextSpan(
                                      text: widget.job.title,
                                      style: theme.textTheme.bodyText2,
                                    )
                                  ]),
                            ),
                            kDefaultSpaceVerticalHalf,
                            RichText(
                              text: TextSpan(
                                  text: "Pay: ",
                                  style: theme.textTheme.bodyText1,
                                  children: [
                                    TextSpan(
                                      text: widget.job.getPay,
                                      style: theme.textTheme.bodyText2,
                                    )
                                  ]),
                            ),
                            kDefaultSpaceVerticalHalf,
                            RichText(
                              text: TextSpan(
                                  text: "Due Date: ",
                                  style: theme.textTheme.bodyText1,
                                  children: [
                                    TextSpan(
                                      text: widget.job.dueDate
                                          .toString()
                                          .split(" ")[0],
                                      style: theme.textTheme.bodyText2,
                                    )
                                  ]),
                            ),
                            kDefaultSpaceVerticalHalf,
                            Text(
                              "Description:",
                              style: theme.textTheme.bodyText1,
                            ),
                            kDefaultSpaceVerticalHalf,
                            MyExpandableText(
                              text: widget.job.description,
                              style: theme.textTheme.bodyText2,
                            ),
                            kDefaultSpaceVertical,
                            Text(
                              "Organization:",
                              style: theme.textTheme.bodyText1,
                            ),
                            kDefaultSpaceVerticalHalf,
                            GestureDetector(
                              onTap: () => Get.to(
                                () => const OrganizationDetailsScreen(),
                              ),
                              child: Material(
                                color: theme.colorScheme.background,
                                borderRadius: BorderRadius.circular(10),
                                elevation: 1,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text(
                                    widget.job.organization.name,
                                    style: theme.textTheme.bodyText1,
                                  ),
                                  subtitle: Text(
                                    widget.job.organization.address,
                                    style: theme.textTheme.caption,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      widget.job.organization.imageUrl,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            kDefaultSpaceVertical,
                            Text(
                              "Upload CV:",
                              style: theme.textTheme.bodyText1,
                            ),
                            kDefaultSpaceVerticalHalf,
                            cv == null
                                ? GestureDetector(
                                    onTap: () async {
                                      cv = await pickFile();
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.background,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.insert_drive_file_rounded,
                                            color: Colors.grey.withOpacity(0.7),
                                          ),
                                          Center(
                                            child: Text(
                                              "Click here to upload file",
                                              style: theme.textTheme.caption,
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              "(csv, png, docx, pdf, jpeg)",
                                              style: theme.textTheme.caption,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Text(
                                    basename(cv!.path),
                                    style: theme.textTheme.bodyText2,
                                  ),
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
                    await Get.find<JobsController>().sendJobApplication(
                      widget.job.id,
                      cv!.path,
                    );
                    Get.back();
                  },
                  child: const Text("Send Job Application"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //TODO-Move this to backend
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["csv", "png", "docx", 'pdf', 'jpeg'],
    );
    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }
}
