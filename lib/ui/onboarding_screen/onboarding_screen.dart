import 'package:connect_org/generated/assets.dart';
import 'package:connect_org/ui/logins_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({Key? key}) : super(key: key);

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (pageController.page != null &&
              pageController.page!.toInt() == 2) {
            Get.off(() => LoginScreen());
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuart,
            );
          }
        },
        child: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  _OnboardingSlide(
                    title: "Welcome to ConnectOrg",
                    description:
                        "Connect with different organizations and collaborate to build awesome projects together.",
                    image: Image.asset(
                      Assets.imagesProjectCollaboration,
                      width: 100.w,
                    ),
                  ),
                  _OnboardingSlide(
                    title: "Project Collaboration",
                    description:
                        "Need some manpower to complete a project? Find and collaborate with different organizations, or hire employees for your organization.",
                    image: Image.asset(
                      Assets.imagesProjectTeam,
                      width: 100.w,
                    ),
                  ),
                  _OnboardingSlide(
                    title: "Search for Jobs",
                    description:
                        "Search and apply to vast amount of jobs available in different organizations.",
                    image: Image.asset(
                      Assets.imagesProjectBuilding,
                      width: 100.w,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 9.sp,
                activeDotColor: Theme.of(context).primaryColor,
                dotColor: Colors.grey,
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final Widget image;

  const _OnboardingSlide({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (orientation == Orientation.portrait) SizedBox(height: 10.h),
          SizedBox(
            height: 40.h,
            child: image,
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
