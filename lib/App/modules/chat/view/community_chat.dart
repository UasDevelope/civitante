import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/color.dart';
import '../controller/chat_controller.dart';
import '../widget/chat_bubble.dart';

class CommunityChat extends StatelessWidget {
  final String communityId;
  const CommunityChat({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController =
        Get.put(ChatController(communityId: communityId));
    chatController.connectSocket();

    return Scaffold(
      appBar: HomeAppbar(title: "Community Chat"),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: chatController.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatController.messages[index];
                    return ChatBubble(
                      text: message["text"],
                      isMe: true,
                      time: message["time"],
                    );
                  },
                )),
          ),

          // Text Field & Send Button
          _buildMessageInput(chatController),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatController chatController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.textFiledBorderColor)),
      ),
      child: Row(
        children: [
          // Text Field
          Expanded(
            child: TextField(
              controller: chatController.messageController,
              style: TextStyle(color: AppColors.appColor),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: AppColors.textFieldHintColor),
                border: InputBorder.none,
              ),
            ),
          ),

          // Send Button
          IconButton(
            onPressed: chatController.sendMessage,
            icon: Icon(Icons.send, color: AppColors.Slate_gray),
          ),
        ],
      ),
    );
  }
}
