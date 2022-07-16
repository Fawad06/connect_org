import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/controllers/home_controller.dart';
import 'package:connect_org/models/organization_model.dart';
import 'package:connect_org/ui/job_screens/all_jobs_screen.dart';
import 'package:connect_org/ui/organizations_screens/edit_organization_screen.dart';
import 'package:connect_org/utils/text_to_list_extension.dart';
import 'package:connect_org/utils/validators.dart';
import 'package:connect_org/widgets/bullet_list_text.dart';
import 'package:connect_org/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/jobs_controller.dart';
import '../../controllers/organizations_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/details_box_widget.dart';
import '../../widgets/my_back_button.dart';
import '../chat_screens/chat_messages_screen.dart';
import 'collaboration_screen.dart';

class OrganizationDetailsScreen extends StatefulWidget {
  const OrganizationDetailsScreen({Key? key, this.showEditButton = false})
      : super(key: key);
  final bool showEditButton;

  @override
  State<OrganizationDetailsScreen> createState() =>
      _OrganizationDetailsScreenState();
}

class _OrganizationDetailsScreenState extends State<OrganizationDetailsScreen> {
  int _selectedIndex = 0;
  final controller = Get.find<OrganizationsController>();
  final _tabs = ["Description", "Services", "Reviews"];
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
    return Obx(() {
      final reviews = controller.orgDetails.value.reviews;
      final services = controller.orgDetails.value.services;
      final organization = controller.orgDetails.value.organization;
      final totalStars = reviews.fold(
        0,
        (int previousValue, element) => previousValue + element.star,
      );
      final rating = totalStars / reviews.length;

      final tabsData = [
        DetailsBox(
          key: const PageStorageKey(0),
          title: "About Company",
          content: BulletListText(
            texts: organization.description.listText,
          ),
        ),
        DetailsBox(
          key: const PageStorageKey(1),
          title: "Services We Provide",
          content: services.isEmpty
              ? const Text("No services listed.")
              : BulletListText(
                  texts: services.map((e) => e.name).toList(),
                ),
        ),
        DetailsBox(
          key: const PageStorageKey(2),
          title: "Reviews From Others",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reviews.isEmpty
                ? [const Text("No reviews given yet.")]
                : reviews.map((e) => ReviewTile(review: e)).toList(),
          ),
        ),
      ];
      return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: controller.isBusy.value,
          child: CustomScrollView(
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
                    imageUrl: organization.imageUrl,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const ColoredBox(color: Colors.black12),
                  ),
                ),
                actions: [
                  if (!widget.showEditButton)
                    Center(
                      child: SquareButton(
                        onPressed: () {
                          Get.find<ChatController>().loadMessages(
                            controller.orgDetails.value.chatId,
                          );
                          Get.to(
                            () => ChatMessagesScreen(
                              otherUserId: organization.id,
                              chatName: organization.name,
                              chatImageUrl: organization.imageUrl,
                              lastMessageTime: DateTime.now(),
                            ),
                          );
                        },
                        icon: Icons.chat_bubble_outline_rounded,
                      ),
                    ),
                  kDefaultSpaceHorizontalHalf,
                  Center(
                    child: SquareButton(
                      onPressed: () {
                        Get.find<JobsController>().loadOrganizationJobs(
                          organization.id,
                        );
                        Get.to(
                          () => AllJobsScreen(
                            organization: organization,
                            showAddJobButton: widget.showEditButton,
                          ),
                        );
                      },
                      icon: Icons.featured_play_list_outlined,
                    ),
                  ),
                  kDefaultSpaceHorizontalHalf,
                ],
              ),
              SliverToBoxAdapter(
                child: StickyHeader(
                  header: buildHeaderContainer(
                    theme,
                    context,
                    organization,
                    rating,
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
        ),
        bottomNavigationBar: buildBottomBar(theme, organization),
      );
    });
  }

  Material buildBottomBar(ThemeData theme, Organization organization) {
    return Material(
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
              Material(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: buildLikeButton(organization),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.userService.user.value?.userType ==
                            "Manager" &&
                        !widget.showEditButton) {
                      controller.userService.clearVariables();
                      controller.userService.loadMyOrganizations();
                      Get.to(
                        () => CollaborationScreen(
                          organization: organization,
                        ),
                      );
                    } else {
                      Get.find<JobsController>().loadOrganizationJobs(
                        organization.id,
                      );
                      Get.to(
                        () => AllJobsScreen(
                          organization: organization,
                          showAddJobButton: widget.showEditButton,
                        ),
                      );
                    }
                  },
                  child: Text(
                    controller.userService.user.value?.userType == "Manager" &&
                            !widget.showEditButton
                        ? "Collaborate"
                        : "View Jobs",
                    style: theme.textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildHeaderContainer(
    ThemeData theme,
    BuildContext context,
    Organization organization,
    double rating,
  ) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          AnimatedSize(
            duration: kDefaultAnimationDuration,
            child: SizedBox(
              height: _shouldAddIndent ? MediaQuery.of(context).padding.top : 0,
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
                  children: [
                    Text(
                      organization.name,
                      style: theme.textTheme.headline5
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    kDefaultSpaceHorizontalHalf,
                    organization.isVerified
                        ? const Icon(
                            Icons.verified_rounded,
                            color: Colors.green,
                          )
                        : const SizedBox.shrink(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: buildPopupMenuButton(theme),
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
                        organization.workStatus
                            ? "Open to Work"
                            : "Closed to Work",
                        style: theme.textTheme.caption,
                      ),
                    ),
                  ],
                ),
                kDefaultSpaceVerticalHalf,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyRatingWidget(rating: rating),
                    Text(
                      "NTN: ${organization.nationalTaxNumber}",
                      style: theme.textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buildButtons(theme),
            ),
          ),
        ],
      ),
    );
  }

  List<ElevatedButton> buildButtons(ThemeData theme) {
    return _tabs
        .asMap()
        .entries
        .map((e) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 38),
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

  LikeButton buildLikeButton(Organization organization) {
    return LikeButton(
      size: 28,
      circleColor: const CircleColor(
        start: Colors.pink,
        end: Colors.red,
      ),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.pink,
        dotSecondaryColor: Colors.red,
      ),
      isLiked: organization.likes > 0,
      onTap: (previousLikedState) {
        final nextLikedState = previousLikedState == true ? false : true;
        Get.find<HomeController>().likeUnLikeOrganization(
          nextLikedState,
          organization.id,
        );
        return Future<bool?>(() => nextLikedState);
      },
      likeBuilder: (bool isLiked) {
        return Icon(
          isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          color: isLiked ? Colors.red : Colors.grey,
          size: 28,
        );
      },
      countBuilder: (
        int? count,
        bool isLiked,
        String text,
      ) {
        return null;
      },
    );
  }

  PopupMenuButton<int> buildPopupMenuButton(ThemeData theme) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_horiz_rounded),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (widget.showEditButton) {
          if (value == 0) {
            Get.to(() {
              Get.find<OrganizationsController>().clearVariables();
              return EditOrganizationScreen(
                organization: controller.orgDetails.value.organization,
              );
            });
          } else {
            _reportOrganization(theme);
          }
        } else {
          if (value == 1) {
            _reportOrganization(theme);
          }
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if (widget.showEditButton)
            PopupMenuItem(
              value: 0,
              child: Text(
                "Edit",
                style: theme.textTheme.bodyText1,
              ),
            ),
          if (!widget.showEditButton)
            PopupMenuItem(
              value: 1,
              child: Text(
                "Report",
                style: theme.textTheme.bodyText1,
              ),
            ),
        ];
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

  void _reportOrganization(ThemeData theme) {
    String reportReason = "";
    kConfirmDialogue(
      context,
      titleText: "Report to admin?",
      content: Column(
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
                minLines: null,
                maxLines: null,
                expands: true,
                onChanged: (value) {
                  reportReason = value;
                },
                validator: Validators.nameValidator,
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
      onConfirm: () async {
        await controller.reportOrganization(reportReason);
        Fluttertoast.showToast(
          msg: "Organization Reported",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: theme.primaryColor,
          gravity: ToastGravity.BOTTOM,
        );
      },
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key? key,
    required this.review,
  }) : super(key: key);

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue,
          backgroundImage: CachedNetworkImageProvider(
            review.reviewerImageUrl,
          ),
        ),
        kDefaultSpaceHorizontalHalf,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.reviewerName,
                style: theme.textTheme.bodyText1,
              ),
              Transform.scale(
                scale: 0.7,
                alignment: Alignment.centerLeft,
                child: MyRatingWidget(
                  rating: review.star.toDouble(),
                  showText: false,
                ),
              ),
              MyExpandableText(
                text: review.message,
                style: theme.textTheme.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyRatingWidget extends StatelessWidget {
  const MyRatingWidget({
    Key? key,
    required this.rating,
    this.showText = true,
  }) : super(key: key);
  final double rating;
  final bool showText;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => index + 1 <= rating
              ? const Icon(
                  Icons.star,
                  color: Colors.yellow,
                )
              : Icon(
                  Icons.star_border_outlined,
                  color: theme.colorScheme.onBackground,
                ),
        ),
        if (showText)
          Text(
            "(${rating.isNaN || rating.isInfinite ? "0" : rating.toStringAsFixed(1)})",
          )
      ],
    );
  }
}
