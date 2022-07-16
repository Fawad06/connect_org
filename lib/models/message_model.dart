import 'package:connect_org/services/user_service.dart';
import 'package:get/get.dart';

class Message {
  final String text;
  final bool isMe;
  final DateTime time;

  Message(this.text, this.isMe, this.time);

  Message.fromJson(Map<String, dynamic> jsonData)
      : text = jsonData["message"],
        isMe = jsonData["senderId"] == Get.find<UserService>().user.value?.id,
        time = DateTime.parse(jsonData["createdAt"]);
}
