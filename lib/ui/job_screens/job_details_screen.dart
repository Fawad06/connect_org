import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/ui/job_screens/apply_job_form.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/utils/date_time_extension.dart';
import 'package:connect_org/utils/text_to_list_extension.dart';
import 'package:connect_org/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../controllers/jobs_controller.dart';
import '../../models/job_model.dart';
import '../../utils/validators.dart';
import '../../widgets/details_box_widget.dart';
import '../../widgets/my_back_button.dart';
import 'edit_job_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({
    Key? key,
    required this.job,
    this.showEdit = false,
  }) : super(key: key);
  final Job job;
  final bool showEdit;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  int _selectedIndex = 0;
  final _tabs = ["Description", "Company", "Reviews"];
  late ScrollController _controller;
  bool _shouldAddIndent = false;
  bool isVisible = true;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.position.addListener(() {
        scrollListener();
      });
    });
    final tabsData = [
      DetailsBox(
        key: const PageStorageKey(0),
        title: "About Job",
        content: BulletListText(
          texts: widget.job.description.listText,
        ),
      ),
      DetailsBox(
        key: const PageStorageKey(1),
        title: "About Company",
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget.job.organization.imageUrl,
              ),
            ),
            kDefaultSpaceHorizontal,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.job.organization.name,
                    style: theme.textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5),
                  MyExpandableText(
                    text: widget.job.organization.description,
                    style: theme.textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      DetailsBox(
        key: const PageStorageKey(3),
        title: "Reviews",
        content: Text(
          "Feature coming soon...",
          style: theme.textTheme.caption,
        ),
      ),
    ];
    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.scaffoldBackgroundColor,
            toolbarHeight: 90,
            expandedHeight: 30.h,
            title: SquareButton(
              onPressed: () => Get.back(),
              icon: Icons.arrow_back_ios_rounded,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: widget.job.imageUrl,
                width: double.maxFinite,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (
                  context,
                  url,
                  downloadProgress,
                ) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StickyHeader(
              header: Column(
                children: [
                  AnimatedSize(
                    duration: kDefaultAnimationDuration,
                    child: SizedBox(
                      height: _shouldAddIndent
                          ? MediaQuery.of(context).padding.top
                          : 0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      boxShadow: kContainerShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.job.title,
                              style: theme.textTheme.headline5
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            PopupMenuButton<int>(
                              icon: const Icon(Icons.more_horiz_rounded),
                              padding: EdgeInsets.zero,
                              onSelected: (value) {
                                switch (value) {
                                  case 0:
                                    if (widget.showEdit) {
                                      Get.find<JobsController>()
                                          .clearVariables();
                                      Get.to(() {
                                        return EditJobScreen(
                                          job: widget.job,
                                        );
                                      });
                                    }
                                    break;
                                  case 1:
                                    if (!widget.showEdit) {
                                      _reportJob(theme);
                                    }
                                    break;
                                  default:
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  if (widget.showEdit)
                                    PopupMenuItem(
                                      value: 0,
                                      child: Text(
                                        "Edit",
                                        style: theme.textTheme.bodyText1,
                                      ),
                                    ),
                                  if (!widget.showEdit)
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "Report",
                                        style: theme.textTheme.bodyText1,
                                      ),
                                    ),
                                ];
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              widget.job.getPay,
                              style: theme.textTheme.caption,
                            ),
                            kDefaultSpaceHorizontalHalf,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                widget.job.isFullTime
                                    ? "Full Time"
                                    : "Part Time",
                                style: theme.textTheme.caption,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${widget.job.dueDate.getStringTime()} left",
                              style: theme.textTheme.caption?.copyWith(
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: buildTapButtons(theme),
                    ),
                  ),
                ],
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedSwitcher(
                  duration: kDefaultAnimationDuration,
                  child: tabsData[_selectedIndex],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        elevation: 8,
        child: AnimatedSize(
          duration: kDefaultAnimationDuration,
          curve: Curves.easeOut,
          child: Container(
            height: isVisible ? 100 : 0,
            width: double.maxFinite,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: kContainerShadow,
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.showEdit) {
                        Get.to(() => EditJobScreen(job: widget.job));
                      } else {
                        Get.to(() => JobApplicationForm(job: widget.job));
                      }
                    },
                    child: Text(
                      widget.showEdit ? "Edit Job" : "Apply Now",
                      style: theme.textTheme.bodyText1
                          ?.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: theme.colorScheme.onBackground,
                      minimumSize: const Size(double.maxFinite, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<ElevatedButton> buildTapButtons(ThemeData theme) {
    return _tabs
        .asMap()
        .entries
        .map((e) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: _selectedIndex == e.key
                    ? theme.colorScheme.onBackground
                    : theme.colorScheme.background,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = e.key;
                });
              },
              child: Text(
                e.value,
                style: theme.textTheme.bodyText1?.copyWith(
                  color: _selectedIndex == e.key
                      ? Colors.white
                      : theme.textTheme.headline6?.color,
                ),
              ),
            ))
        .toList();
  }

  void _reportJob(ThemeData theme) {
    final _formKey = GlobalKey<FormState>();
    kConfirmDialogue(
      context,
      titleText: "Report to admin?",
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter a brief reason for report",
              style: theme.textTheme.bodyText1,
            ),
            kDefaultSpaceVerticalHalf,
            SizedBox(
              height: 120,
              child: Material(
                elevation: 1,
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(10),
                child: TextFormField(
                  validator: Validators.nameValidator,
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: kTextFormFieldDecoration(
                    theme.colorScheme.background,
                    null,
                    "Reason...",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onConfirm: () {
        if (_formKey.currentState!.validate()) {
          Fluttertoast.showToast(
            msg: "Organization Reported",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: theme.primaryColor,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
    );
  }

  void scrollListener() {
    if (_controller.position.pixels <= 30.h && _shouldAddIndent == true) {
      setState(() {
        _shouldAddIndent = false;
        isVisible =
            _controller.position.userScrollDirection == ScrollDirection.forward;
      });
    } else if (_controller.position.pixels > 30.h &&
        _shouldAddIndent == false) {
      setState(() {
        _shouldAddIndent = true;
        isVisible =
            _controller.position.userScrollDirection == ScrollDirection.forward;
      });
    }
  }
}

class BulletListText extends StatelessWidget {
  const BulletListText({
    Key? key,
    required this.texts,
  }) : super(key: key);

  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts
          .map((e) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "◉ ",
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headline6
                        ?.copyWith(fontSize: 24, height: 0.9),
                  ),
                  Expanded(
                    child: Text(
                      "$e\n",
                      style: theme.textTheme.bodyText2,
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }
}
