import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class ImageListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.postController;

    return Obx(() {
      // Check if both images and videos are empty
      if (controller.images.isEmpty && controller.videos.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        height: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.images.length + controller.videos.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index < controller.images.length) {
              // Handle image or video-thumbnail URL
              final rawUrl = controller.images[index];
              final isVideoUrl = rawUrl.contains('&thumbnail=');
              final displayUrl =
                  isVideoUrl ? rawUrl.split('&thumbnail=')[1] : rawUrl;

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        displayUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
                    ),
                  ),
                  // Cancel Button for Image
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.images.removeAt(index);
                        controller.update(); // Update UI
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Display Video File with generated thumbnail
              final videoIndex = index - controller.images.length;
              final isVideoUrl =
                  controller.videos[videoIndex].contains('&thumbnail=');
              final displayUrl = isVideoUrl
                  ? controller.videos[videoIndex].split('&thumbnail=')[1]
                  : controller.images[videoIndex];
              log("Video url is ${controller.videos[videoIndex]}");
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(displayUrl),
                    ),
                  ),
                  // Play Icon to indicate video file
                  Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 40,
                    ),
                  ),
                  // Cancel Button for Video
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.videos.removeAt(videoIndex);
                        controller.update(); // Update UI
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
    });
  }
}
