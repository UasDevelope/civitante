import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/video_player_cntroller.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String url;

  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VideoController controller = Get.put(VideoController(url));

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(), // Go back to previous screen
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 28.0, // Customize icon size
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: GetBuilder<VideoController>(
        builder: (_) {
          if (_.chewieController != null &&
              _.chewieController!.videoPlayerController.value.isInitialized) {
            return Center(
              child: Chewie(controller: _.chewieController!),
            );
          } else {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                  strokeWidth: 4,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
