import 'package:connect_org/controllers/chat_controller.dart';
import 'package:connect_org/controllers/home_controller.dart';
import 'package:connect_org/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../models/chat_model.dart';
import '../../widgets/chat_card.dart';
import 'chat_messages_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with AutomaticKeepAliveClientMixin<ChatsScreen> {
  final homeController = Get.find<HomeController>();
  int selectedIndex = 0;

  final _myAnimatedListKey = GlobalKey<AnimatedListState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            //   color: Theme.of(context).scaffoldBackgroundColor,
            //   child: Row(
            //     children: [
            //       FilledOutlineButton(
            //         onPressed: () {
            //           // unFilterOnline();
            //         },
            //         text: "Recent",
            //         isFilled: selectedIndex == 0 ? true : false,
            //       ),
            //       const SizedBox(width: 20),
            //       FilledOutlineButton(
            //         onPressed: () {
            //           // filterOnline();
            //         },
            //         text: "Online",
            //         isFilled: selectedIndex == 1 ? true : false,
            //       )
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Chats,",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (homeController.chats.isEmpty) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(Assets.imagesBox),
                        Text(
                          "No chats found!",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  );
                }
                return AnimationLimiter(
                  child: RefreshIndicator(
                    onRefresh: homeController.refreshChatData,
                    child: AnimatedList(
                      key: _myAnimatedListKey,
                      initialItemCount: homeController.chats.length,
                      itemBuilder: (context, index, animation) {
                        final chat = homeController.chats[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: kDefaultAnimationDuration,
                          child: SlideAnimation(
                            verticalOffset: 100,
                            child: FadeInAnimation(
                              child: buildChatItem(animation, chat),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  FadeTransition buildChatItem(Animation<double> animation, Chat chat) {
    return FadeTransition(
      opacity: CurvedAnimation(curve: Curves.easeOutQuart, parent: animation),
      child: ChatCard(
        chat: chat,
        onPressed: () {
          Get.find<ChatController>().loadMessages(chat.id);
          Get.to(
            () => ChatMessagesScreen(
              otherUserId: chat.otherUserId,
              chatName: chat.name,
              chatImageUrl: chat.imageUrl,
              lastMessageTime: chat.lastMessage.time,
            ),
          );
        },
      ),
    );
  }

  // void filterOnline() {
  //   if (filteredChats.isEmpty) {
  //     setState(() {
  //       selectedIndex = 1;
  //       filteredChats = Map.from(chats.asMap());
  //       filteredChats.removeWhere((key, value) => value.isOnline);
  //       int count = 0;
  //       filteredChats.forEach((key, value) {
  //         if (count > 0) key -= count;
  //         chats.removeAt(key);
  //         _myAnimatedListKey.currentState?.removeItem(
  //           key,
  //           (context, animation) => buildChatItem(animation, value),
  //         );
  //         count++;
  //       });
  //     });
  //   }
  // }
  //
  // void unFilterOnline() {
  //   setState(() {
  //     selectedIndex = 0;
  //     filteredChats.forEach((key, value) {
  //       chats.insert(key, value);
  //       _myAnimatedListKey.currentState?.insertItem(key);
  //     });
  //     filteredChats.clear();
  //   });
  // }
}
