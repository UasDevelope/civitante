import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var messages = <Message>[].obs;

  void sendMessage(String text, bool isUser) {
    if (text.isNotEmpty) {
      messages.add(Message(
        text: text,
        isUser: isUser,
        time: DateTime.now(),
        isRead: false,
      ));
    }
  }

  void markAsRead(int index) {
    if (messages[index].isUser) {
      messages[index] = messages[index].copyWith(isRead: true);
    }
  }
}

class Message {
  final String text;
  final bool isUser;
  final DateTime time;
  final bool isRead;

  Message({
    required this.text,
    required this.isUser,
    required this.time,
    this.isRead = false,
  });

  Message copyWith({bool? isRead}) {
    return Message(
      text: text,
      isUser: isUser,
      time: time,
      isRead: isRead ?? this.isRead,
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String chatTitle;
  final ChatController controller;
  final TextEditingController messageController = TextEditingController();

  ChatScreen({
    Key? key,
    required this.chatTitle,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(title: chatTitle),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller
                      .messages[controller.messages.length - 1 - index];
                  return Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: message.isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: message.isUser ? 0 : 2,
                                color: Color(0xffA7A7A7)),
                            color: message.isUser
                                ? Color.fromRGBO(0, 0, 0, 0.57)
                                : null,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: AppText(
                              text: message.text,
                              fontWeight: FontWeight.w400,
                              color: message.isUser
                                  ? AppColors.white
                                  : AppColors.appColor,
                              fontSize: 14),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF1F1F1),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText(
                                  text: "${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}",
                                ),
                                const SizedBox(width: 6),
                                if (message.isUser)
                                  Image.asset(
                                    AppImages.tick,
                                    color: message.isRead
                                        ? Colors.blue
                                        : Colors.green,
                                    height: 10,
                                  ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon:  Image.asset(AppImages.emojie,height:20,),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:  InputDecoration(
                      hintText: "Type a message here",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon:  Image.asset(AppImages.chatCamera,color:AppColors.Slate_gray,height:20,),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = messageController.text.trim();
                    controller.sendMessage(text, true);
                    messageController.clear();

                    // Simulate a response and mark the previous message as read
                    Future.delayed(const Duration(seconds: 1), () {
                      controller.sendMessage(
                        "Thank you for your message!",
                        false,
                      );
                      controller.markAsRead(controller.messages.length - 2);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminContactScreen extends StatelessWidget {
  final ChatController adminChatController = Get.put(ChatController());
  final ChatController userChatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ChatScreen(
              chatTitle: "Admin Chat",
              controller: adminChatController,
            ),
          ),
        ],
      ),
    );
  }
}
