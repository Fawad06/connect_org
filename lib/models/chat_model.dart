import 'package:connect_org/services/user_service.dart';
import 'package:get/get.dart';

import 'message_model.dart';

class Chat {
  final String id;
  final String name;
  final String imageUrl;
  final String otherUserId;
  final Message lastMessage;
  Chat({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.otherUserId,
  });

  Chat.fromJson(
    Map<String, dynamic> chatJsonData,
    this.id,
    String userId1,
    String userId2,
  )   : name = chatJsonData["name"],
        otherUserId = userId1 == Get.find<UserService>().user.value!.id
            ? userId2
            : userId1,
        imageUrl = chatJsonData["image"] ??
            "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
        lastMessage = Message.fromJson(chatJsonData["lastMessage"]);
}
