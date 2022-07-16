import 'package:connect_org/models/message_model.dart';
import 'package:connect_org/services/user_service.dart';
import 'package:connect_org/utils/log_extension.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';

class ChatController extends GetxController {
  final apiService = Get.find<ApiService>();
  final userService = Get.find<UserService>();
  final RxList<Message> messages = <Message>[].obs;
  RxBool isBusy = false.obs;
  String newMessageText = "";

  Future loadMessages(String chatId) async {
    try {
      messages.clear();
      isBusy.value = true;
      final allMessages = await apiService.getAllMessages(chatId);
      messages.assignAll(allMessages);
    } catch (e) {
      "Message from ChatController: Error loading messages: ${e.toString()}"
          .log();
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> sendMessage({required String otherUserId}) async {
    try {
      final message = await apiService.sendChatMessage(
        messageText: newMessageText,
        senderId: userService.user.value!.id,
        userId: userService.user.value!.id,
        otherUserId: otherUserId,
      );
      messages.add(message);
      "Message from ChatController: message sent and added to list.".log();
    } catch (e) {
      "Message from ChatController: Error sending message: ${e.toString()}"
          .log();
    }
  }
}
