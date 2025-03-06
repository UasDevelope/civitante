import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../shared/color.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final String senderName;
  final String? profileImage;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isMe,
    required this.time,
    required this.senderName,
    this.profileImage,
  }) : super(key: key);
  RegExp emojiRegex() {
    return RegExp(
      r'^[\u203C-\u3299\ufe0f\u00A9\u00AE\u200D\u3030\uD83C-\uDBFF\uDC00-\uDFFF]+$',
      unicode: true,
    );
  }

  bool _isEmojiOnly(String input) {
    final regex = emojiRegex();
    return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    bool isEmoji = _isEmojiOnly(text);
    log("Is emoji $isEmoji $text");
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.greyShade,
                backgroundImage: (profileImage != null && profileImage!.isNotEmpty)
                    ? NetworkImage(profileImage!)
                    : null,
                child: (profileImage == null || profileImage!.isEmpty)
                    ? Icon(Icons.person, color: AppColors.Slate_gray, size: 28)
                    : null,
              ),
            ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: isEmoji ? 14 : 10, horizontal: 14),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                gradient: isMe
                    ? LinearGradient(
                  colors: [AppColors.blue, AppColors.moreblue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : LinearGradient(
                  colors: [AppColors.greyShade, AppColors.light_gray],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isMe ? Radius.circular(20) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        senderName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.appColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? AppColors.white : AppColors.appColor,
                      fontSize: isEmoji ? 28 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isMe
                            ? AppColors.white.withOpacity(0.7)
                            : AppColors.Slate_gray,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
