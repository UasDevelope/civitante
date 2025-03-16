import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/Post.dart';
import '../../../utilse/widgets.dart';
import '../controller/home_controller.dart';
import 'dots.dart';

class SliderWithLabels extends StatelessWidget {
  final Post post;
  final int index;
  const SliderWithLabels({super.key, required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 5),
              for (int i = 1; i <= 5; i++) ...[
                Obx(
                      () => Dot(
                    color: post.rate?.value != null && post.rate!.value! >= i
                        ? AppColors.blue
                        : AppColors.Slate_gray,
                    onPress: () async {
                      await homeController.addPostRating(post.id, i, index);
                    },
                  ),
                ),
                if (i < 5)
                  Expanded(
                    child: Obx(
                          () => Divider(
                        thickness: 1,
                        color: post.rate?.value != null && post.rate!.value! > i
                            ? Colors.yellowAccent
                            : AppColors.Slate_gray,
                      ),
                    ),
                  ),
              ],
              const SizedBox(width: 25),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                AppText(text: "Bad", color: AppColors.Slate_gray, fontWeight: FontWeight.w400, fontSize: 8),
                AppText(text: "Okay", color: AppColors.Slate_gray, fontWeight: FontWeight.w400, fontSize: 8),
                AppText(text: "Good", color: AppColors.Slate_gray, fontWeight: FontWeight.w400, fontSize: 8),
                AppText(text: "Great", color: AppColors.Slate_gray, fontWeight: FontWeight.w400, fontSize: 8),
                AppText(text: "Excellent", color: AppColors.Slate_gray, fontWeight: FontWeight.w400, fontSize: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}