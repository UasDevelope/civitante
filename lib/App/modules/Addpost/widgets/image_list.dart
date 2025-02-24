import 'dart:io';

import 'package:flutter/material.dart';

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
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      controller.images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Cancel Button
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      controller.images.removeAt(index); // Remove the image
                      controller.update(); // Update UI (if using GetX)
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.7), // Red background
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close, // Close icon
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

    });
  }
}
