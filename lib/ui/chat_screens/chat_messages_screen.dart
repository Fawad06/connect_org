import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_org/controllers/chat_controller.dart';
import 'package:connect_org/utils/date_time_extension.dart';
import 'package:connect_org/widgets/my_back_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../utils/constants.dart';
import '../../widgets/message_bubble.dart';

class ChatMessagesScreen extends StatelessWidget {
  ChatMessagesScreen({
    Key? key,
    required this.chatName,
    required this.chatImageUrl,
    required this.otherUserId,
    required this.lastMessageTime,
  }) : super(key: key);

  final String otherUserId;
  final String chatName;
  final String chatImageUrl;
  final DateTime lastMessageTime;
  final _formKey = GlobalKey<FormState>();
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(theme),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() {
                  if (chatController.isBusy.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (chatController.messages.isEmpty) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Assets.imagesBox),
                          Text(
                            "No messages found!",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    );
                  }
                  final messages = chatController.messages.reversed.toList();
                  return ListView.builder(
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final message = messages[index];
                      return Column(
                        children: [
                          MessageBubble(
                            message: message,
                            organizationImageUrl: chatImageUrl,
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
            Container(
              padding: kDefaultPadding,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 0),
                    blurRadius: 32,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20 * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.sentiment_satisfied_alt_outlined,
                              color: theme.textTheme.bodyText1!.color!
                                  .withOpacity(0.64),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Form(
                            key: _formKey,
                            child: Expanded(
                              child: TextFormField(
                                validator: (value) =>
                                    value != null && value.isNotEmpty
                                        ? null
                                        : "Write a message",
                                onChanged: (value) {
                                  chatController.newMessageText = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: "Type message",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Icon(
                          //     Icons.attach_file,
                          //     color: theme.textTheme.bodyText1!.color!
                          //         .withOpacity(0.64),
                          //   ),
                          // ),
                          // const SizedBox(width: 5),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Icon(
                          //     Icons.camera_alt_outlined,
                          //     color: theme.textTheme.bodyText1!.color!
                          //         .withOpacity(0.64),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  kDefaultSpaceHorizontal,
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.reset();
                        chatController.sendMessage(otherUserId: otherUserId);
                      }
                    },
                    child: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(ThemeData theme) {
    return AppBar(
      toolbarHeight: 90,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          kDefaultSpaceHorizontalHalf,
          SquareButton(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: () => Get.back(),
          ),
          kDefaultSpaceHorizontal,
          MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              await Get.defaultDialog(
                content: CachedNetworkImage(
                  imageUrl: chatImageUrl,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.contain,
                ),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: CachedNetworkImageProvider(
                    chatImageUrl,
                  ),
                ),
                const SizedBox(width: 20 * 0.75),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatName,
                      style: theme.textTheme.bodyText1?.copyWith(fontSize: 18),
                    ),
                    Text(
                      lastMessageTime.getStringTime(),
                      style: theme.textTheme.bodyText1?.copyWith(fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
