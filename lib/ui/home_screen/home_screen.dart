import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_org/controllers/home_controller.dart';
import 'package:connect_org/controllers/organizations_controller.dart';
import 'package:connect_org/generated/assets.dart';
import 'package:connect_org/ui/organizations_screens/organization_details.dart';
import 'package:connect_org/ui/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../widgets/my_organization_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  final controller = Get.find<HomeController>();
  final _images = [
    Assets.imagesCarousel1,
    Assets.imagesCarousel2,
    Assets.imagesCarousel3,
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: controller.refreshOrgData,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to\nConnectORG",
                    style: theme.textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  kDefaultSpaceVertical,
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
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.background,
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
                      kDefaultSpaceHorizontal,
                      Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground,
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
                      kDefaultSpaceHorizontal,
                    ],
                  ),
                  kDefaultSpaceVertical,
                  Text(
                    "Popular Jobs",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  kDefaultSpaceVerticalHalf,
                  CarouselSlider(
                    items: _images.map((e) => buildSlide(e)).toList(),
                    options: CarouselOptions(
                      height: 150,
                      viewportFraction: 1,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      pauseAutoPlayInFiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 700),
                      autoPlayCurve: Curves.easeOutQuart,
                    ),
                  ),
                  kDefaultSpaceVertical,
                  Text(
                    "Top Organizations",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  kDefaultSpaceVerticalHalf,
                  Obx(() {
                    if (controller.isBusy.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.organizations.isEmpty) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Assets.imagesBox),
                            Text(
                              "No organizations found!",
                              style: theme.textTheme.bodyText2,
                            ),
                          ],
                        ),
                      );
                    }
                    final orgs = controller.organizations.toList();
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orgs.length,
                      itemBuilder: (context, index) => OrganizationWidget(
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
                      ),
                      separatorBuilder: (_, __) => kDefaultSpaceVerticalHalf,
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSlide(String e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: kContainerShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          e,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
