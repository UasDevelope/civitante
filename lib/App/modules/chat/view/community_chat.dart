import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/modules/loading/empty_data.dart';
import 'package:civitante/App/modules/shimmer/chat_bubble_shimmer.dart';
import 'package:civitante/App/service/chat_service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
    ChatService.connectSocket();

    return Scaffold(
      appBar: HomeAppbar(title: "Community Chat"),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: Obx(() {
              if (chatController.isLoading.value) {
                return ChatBubbleShimmerList();
              } else if (chatController.messages.isEmpty) {
                return LottieAnimationWidget();
              } else {
                return ListView.builder(
                  controller: chatController.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    if (index == 0 && chatController.isLoadingOlder.value) {
                      return _buildLoadingOlderAnimation(); // Animated loading for older messages
                    }
                    final messageIndex = chatController.isLoadingOlder.value ? index - 1 : index;
                    final message = chatController.messages[messageIndex];
                    return ChatBubble(
                      text: message["text"],
                      isMe: message["isMe"],
                      time: message["time"],
                      senderName: message["sender"],
                      profileImage: message[
                          "senderProfileImage"], // Add profile image URL if available
                    );

                  },
                );
              }
            }),
          ),

          // Text Field & Send Button
          _buildMessageInput(chatController),
        ],
      ),
    );
  }


}
Widget _buildLoadingOlderAnimation() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.4, end: 1.0).animate(
          CurvedAnimation(
            parent: ModalRoute.of(Get.context!)?.animation ??
                AnimationController(
                  vsync: Navigator.of(Get.context!), // Use a valid TickerProvider
                  duration: const Duration(milliseconds: 300), // Provide a default duration
                ),
            curve: Curves.easeInOut,
          ),

        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha:0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.Slate_gray),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Loading older messages...",
                style: TextStyle(
                  color: AppColors.Slate_gray,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildMessageInput(ChatController chatController) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Message Input Container
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.white.withValues(alpha:0.95),
              AppColors.white.withValues(alpha:0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.textFiledBorderColor.withValues(alpha:0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Emoji Button
            AnimatedScaleButton(
              icon: Icons.emoji_emotions_outlined,
              color: AppColors.Slate_gray.withValues(alpha:0.7),
              onPressed: () {
                chatController.toggleEmojiPicker();
              },
              tooltip: 'Add Emoji',
            ),

            // Text Field
            Expanded(
              child: TextField(
                controller: chatController.messageController,
                style: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(
                    color: AppColors.textFieldHintColor.withValues(alpha:0.5),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ),
            ),

            // Send Button
            AnimatedScaleButton(
              icon: Icons.send,
              color: Colors.white,
              gradient: LinearGradient(
                colors: [
                  AppColors.Slate_gray.withValues(alpha:0.9),
                  AppColors.Slate_gray.withValues(alpha:1.0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onPressed: chatController.sendMessage,
              tooltip: 'Send Message',
            ),
          ],
        ),
      ),

      // Emoji Picker (shown/hidden based on state)
      Obx(
            () => Offstage(
          offstage: !chatController.showEmojiPicker.value,
          child: SizedBox(
            height: 250, // Fixed height for emoji picker
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                chatController.messageController.text += emoji.emoji;
              },
              config: Config(
  height: 280,
  checkPlatformCompatibility: true,
  locale: const Locale('en'),
  emojiTextStyle: TextStyle(
  fontSize: 26, // Slightly smaller for balance
  color: AppColors.appColor,
  ),
  customBackspaceIcon: Icon(
  Icons.backspace,
  color: AppColors.Slate_gray.withValues(alpha: 0.8),
  size: 22,
  ),
  customSearchIcon: Icon(
  Icons.search,
  color: AppColors.Slate_gray.withValues(alpha:0.8),
  size: 22,
  ),
  viewOrderConfig:  ViewOrderConfig(
  top:EmojiPickerItem.categoryBar,
  middle: EmojiPickerItem.emojiView,
  bottom: EmojiPickerItem.searchBar,
  ),
  emojiViewConfig: EmojiViewConfig(
  columns: 9, // Dense grid for modern look
  emojiSizeMax: 28,
  backgroundColor: AppColors.white.withValues(alpha:0.98),
  recentsLimit: 40, // More recents for frequent users
  ),
  skinToneConfig: const SkinToneConfig(
  enabled: true,
  dialogBackgroundColor: Colors.white,
  indicatorColor: AppColors.Slate_gray,
  ),
  categoryViewConfig: CategoryViewConfig(
  backgroundColor: AppColors.light_gray.withValues(alpha:0.9),
  indicatorColor: AppColors.Slate_gray,
  iconColor: AppColors.Slate_gray.withValues(alpha:0.6),
  iconColorSelected: AppColors.Slate_gray,
  dividerColor: AppColors.textFiledBorderColor.withValues(alpha:0.3),
  tabBarHeight: 48,
  ),
  bottomActionBarConfig: BottomActionBarConfig(
  enabled: true,
  backgroundColor: AppColors.white,
  buttonColor: AppColors.white,
  buttonIconColor: AppColors.Slate_gray.withValues(alpha:0.8),
  ),
  searchViewConfig: SearchViewConfig(
  backgroundColor: AppColors.light_gray.withValues(alpha:0.95),
  buttonIconColor: AppColors.white,
  hintText: "Search emojis...",

  ),),
            ),
          ),
        ),
      ),
    ],
  );
}
// Custom Animated Button Widget for Consistency and Beauty
class AnimatedScaleButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;
  final Gradient? gradient;

  const AnimatedScaleButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
    this.gradient,
  }) : super(key: key);

  @override
  _AnimatedScaleButtonState createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.9),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.gradient,
              color: widget.gradient == null
                  ? AppColors.white.withValues(alpha:0.1)
                  : null, // Fallback for non-gradient buttons
            ),
            child: Icon(
              widget.icon,
              color: widget.color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}


