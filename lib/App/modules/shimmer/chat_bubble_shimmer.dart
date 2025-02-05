import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/color.dart'; // Import your color palette

class ChatBubbleShimmer extends StatelessWidget {
  final bool isMe;

  const ChatBubbleShimmer({Key? key, required this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe)
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.greyShade,
                child: Icon(Icons.person, color: Colors.white),
              ),
            SizedBox(width: isMe ? 0 : 8),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
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
                      child: Container(
                        width: 80,
                        height: 10,
                        color: AppColors.appColor,
                      ),
                    ),
                  Container(
                    width: 150,
                    height: 16,
                    color: AppColors.appColor,
                  ),
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 50,
                      height: 8,
                      color: AppColors.white.withOpacity(0.7),
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
}

class ChatBubbleShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> shimmerBubbles = [];

    for (int i = 0; i < 20; i++) {
      shimmerBubbles.add(ChatBubbleShimmer(isMe: i.isEven));
    }

    return ListView(
      children: shimmerBubbles,
    );
  }
}
