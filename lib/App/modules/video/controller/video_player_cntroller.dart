import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  final String videoUrl;

  VideoController(this.videoUrl);

  @override
  void onInit() {
    super.onInit();
    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: false,
        );
        update(); // Notify UI
      });
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
