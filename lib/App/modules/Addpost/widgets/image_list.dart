import 'dart:io';

import '../../../controller/controller_locate.dart';
import '../../../utilse/widgets.dart';

class ImageListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.postController;
    return Obx(() {
      // Use Obx to reactively rebuild the widget when images change
      return Container(
        height: 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.images.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10), // Set border radius for each image
                child: Image.network(
                  controller.images[index], // Load local image
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
