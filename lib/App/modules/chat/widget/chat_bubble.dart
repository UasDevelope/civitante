import 'package:flutter/material.dart';
import '../../../shared/color.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final String senderName;
  final String? profileImage; // Nullable profile image

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isMe,
    required this.time,
    required this.senderName,
    this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) // Show avatar only for the other user
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.greyShade,
              backgroundImage:
                  (profileImage != null && profileImage!.isNotEmpty)
                      ? NetworkImage(profileImage!)
                      : null,
              child: (profileImage == null || profileImage!.isEmpty)
                  ? Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          SizedBox(width: isMe ? 0 : 8), // Add spacing for non-sender messages
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isMe ? AppColors.Slate_gray : AppColors.greyShade,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: isMe ? Radius.circular(16) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(16),
              ),
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
                    fontSize: 16,
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
        ],
      ),
    );
  }
}
