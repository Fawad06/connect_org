import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/controllers/home_controller.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/ui/chat_screens/chats_screen.dart';
import 'package:connect_org/ui/home_screen/home_screen.dart';
import 'package:connect_org/ui/job_screens/jobs_screen.dart';
import 'package:connect_org/ui/notification_screen/notification_screen.dart';
import 'package:connect_org/ui/profile_screen/profile_screen.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:connect_org/widgets/my_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../widgets/square_avatar.dart';
import '../contact_screen/contact_us_screen.dart';
import '../organizations_screens/my_organizations.dart';
import '../project_screens/projects_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _scrollController;
  final homeController = Get.find<HomeController>();

  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(
      length: _navBarScreens().length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => kConfirmDialogue(
        context,
        titleText: "Are you sure?",
        content: Text(
          "Press confirm to exit.",
          style: theme.textTheme.bodyText2,
        ),
      ),
      child: Scaffold(
        drawer: buildDrawer(theme),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  toolbarHeight: 90,
                  automaticallyImplyLeading: false,
                  snap: true,
                  floating: true,
                  title: Builder(builder: (context) {
                    return Row(
                      children: [
                        SquareButton(
                          child: SvgPicture.asset(
                            Assets.iconsMenu,
                            width: 24,
                            height: 24,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "ConnectOrg",
                              style: theme.textTheme.headline6,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(
                            () => ProfileScreen(),
                          ),
                          child: SquareAvatar(
                            backgroundColor: Colors.blue,
                            backgroundImage:
                                homeController.user.value?.imageUrl != null
                                    ? CachedNetworkImageProvider(
                                        homeController.user.value!.imageUrl!,
                                      ) as ImageProvider
                                    : const AssetImage(Assets.imagesProfileDp),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: _navBarScreens(),
          ),
        ),
        bottomNavigationBar: MyBottomNavBarWidget(
          selectedItemCallBack: (setSelectedItem) {
            _tabController.addListener(() {
              setSelectedItem(_tabController.index);
            });
          },
          onItemSelected: (int index) {
            _tabController.animateTo(
              index,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutQuart,
            );
          },
          isVisibleCallBack: (setIsVisible) {
            _scrollController.addListener(() {
              if (_scrollController.position.userScrollDirection ==
                      ScrollDirection.reverse &&
                  isVisible != false) {
                isVisible = false;
                setIsVisible(isVisible);
              }
              if (_scrollController.position.userScrollDirection ==
                      ScrollDirection.forward &&
                  isVisible != true) {
                isVisible = true;
                setIsVisible(isVisible);
              }
            });
          },
        ),
      ),
    );
  }

  List<Widget> _navBarScreens() {
    return [
      const HomeScreen(),
      JobsScreen(),
      const ChatsScreen(),
      NotificationScreen(),
    ];
  }

  Drawer buildDrawer(ThemeData theme) {
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.to(() => ProfileScreen());
            },
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blue,
                  backgroundImage: homeController.user.value?.imageUrl != null
                      ? CachedNetworkImageProvider(
                          homeController.user.value!.imageUrl!,
                        ) as ImageProvider
                      : const AssetImage(Assets.imagesProfileDp),
                ),
                title: Text(
                    "${homeController.user.value?.firstName} ${homeController.user.value?.lastName}"),
                subtitle: Text("${homeController.user.value?.email}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // if(homeController.user.value?.userType == "Manager")
                //       buildDrawerTile(
                //         Icons.dashboard_rounded,
                //         "DashBoard",
                //         theme,
                //         () => Get.to(() => const DashboardScreen()),
                //       ) ,
                kDefaultSpaceVerticalHalf,
                buildDrawerTile(
                  FontAwesomeIcons.user,
                  "Profile",
                  theme,
                  () => Get.to(
                    () => ProfileScreen(),
                  ),
                ),
                if (homeController.user.value?.userType == "Manager")
                  kDefaultSpaceVerticalHalf,
                if (homeController.user.value?.userType == "Manager")
                  buildDrawerTile(
                    FontAwesomeIcons.compass,
                    "My Organizations",
                    theme,
                    () {
                      Get.find<UserService>().loadMyOrganizations();
                      Get.to(() => MyOrganizationsScreen());
                    },
                  ),
                if (homeController.user.value?.userType == "Manager")
                  kDefaultSpaceVerticalHalf,
                if (homeController.user.value?.userType == "Manager")
                  buildDrawerTile(
                    FontAwesomeIcons.envelope,
                    "My Projects",
                    theme,
                    () {
                      Get.find<UserService>().loadMyProjects();
                      Get.to(() => const ProjectsScreen());
                    },
                  ),
                kDefaultSpaceVerticalHalf,
                buildDrawerTile(
                  FontAwesomeIcons.phone,
                  "Contact Us",
                  theme,
                  () => Get.to(() => const ContactUsScreen()),
                ),
                kDefaultSpaceVerticalHalf,
                // buildDrawerTile(
                //   Icons.settings,
                //   "Settings",
                //   theme,
                //   () => Get.to(() => const SettingsScreen()),
                // ),
                // kDefaultSpaceVerticalHalf,
                buildDrawerTile(
                  FontAwesomeIcons.rightFromBracket,
                  "Logout",
                  theme,
                  () => homeController.logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerTile(
    IconData icon,
    String label,
    ThemeData theme,
    VoidCallback onPressed,
  ) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: theme.colorScheme.background,
        leading: Icon(
          icon,
          size: theme.iconTheme.size,
          color: theme.iconTheme.color,
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyText1,
        ),
        onTap: () {
          Get.back();
          onPressed();
        },
      ),
    );
  }
}

class MyBottomNavBarWidget extends StatefulWidget {
  final Function(int index) onItemSelected;
  final Function(Function(int index) setSelectedItem) selectedItemCallBack;
  final Function(Function(bool visible) setIsVisible) isVisibleCallBack;
  const MyBottomNavBarWidget({
    Key? key,
    required this.onItemSelected,
    required this.selectedItemCallBack,
    required this.isVisibleCallBack,
  }) : super(key: key);

  @override
  State<MyBottomNavBarWidget> createState() => _MyBottomNavBarWidgetState();
}

class _MyBottomNavBarWidgetState extends State<MyBottomNavBarWidget> {
  bool isVisible = true;
  int selectedIndex = 0;

  @override
  void initState() {
    widget.selectedItemCallBack(setSelectedItem);
    widget.isVisibleCallBack(setIsVisible);
    super.initState();
  }

  void setSelectedItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void setIsVisible(bool visible) {
    setState(() {
      isVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSize(
      duration: kDefaultAnimationDuration,
      curve: Curves.easeOutQuart,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BottomNavyBar(
            curve: Curves.bounceOut,
            itemCornerRadius: 10,
            showElevation: true,
            selectedIndex: selectedIndex,
            backgroundColor: theme.colorScheme.background,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            animationDuration: const Duration(milliseconds: 700),
            containerHeight:
                MediaQuery.of(context).viewInsets.bottom > 0 || !isVisible
                    ? 0
                    : kBottomNavigationBarHeight,
            onItemSelected: widget.onItemSelected,
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text('Home'),
                textAlign: TextAlign.center,
                activeColor: theme.primaryColor,
                inactiveColor: theme.colorScheme.onBackground,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.featured_play_list_outlined),
                title: const Text('Jobs'),
                textAlign: TextAlign.center,
                activeColor: theme.primaryColor,
                inactiveColor: theme.colorScheme.onBackground,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.message_outlined),
                title: const Text('Messages'),
                textAlign: TextAlign.center,
                activeColor: theme.primaryColor,
                inactiveColor: theme.colorScheme.onBackground,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.notifications_active_outlined),
                title: const Text("Notifications"),
                textAlign: TextAlign.center,
                activeColor: theme.primaryColor,
                inactiveColor: theme.colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
