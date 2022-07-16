import 'package:connect_org/controllers/home_controller.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: const PageStorageKey("notificationscreen"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notifications,",
                style: theme.textTheme.headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: homeController.refreshNotificationData,
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: homeController.chats.length,
                      itemBuilder: (context, index) {
                        if (homeController.notifications.isEmpty) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(Assets.imagesBox),
                                Text(
                                  "No notifications found!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: kContainerShadow,
                          ),
                          width: double.maxFinite,
                          height: 80,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              // backgroundImage: CachedNetworkImageProvider(userFawad
                              //         .imageUrl ??
                              //     "ht lt-a 4.jpg"),
                            ),
                            title: Text(
                              "Your Job Application has been rejected",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            subtitle: Text(
                              "Sorry we decided to reject you application",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: const Icon(FontAwesomeIcons.envelopeOpen),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
