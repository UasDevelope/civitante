import 'package:flutter/material.dart';

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
          SizedBox(
            height: 10,
          ),
          // Slider Row with dots
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Obx(
                () => Dot(
                  color: post.rate?.value == 1 ||
                          post.rate?.value == 2 ||
                          post.rate?.value == 3
                      ? Colors.yellowAccent
                      : AppColors.Slate_gray,
                  onPress: () async {
                    await homeController.addPostRating(post.id, 1, index);
                  },
                ),
              ),
              Expanded(
                child: Obx(
                  () => Divider(
                    thickness: 1,
                    color: post.rate?.value == 2 || post.rate?.value == 3
                        ? Colors.yellowAccent
                        : AppColors.Slate_gray,
                  ),
                ),
              ),
              Obx(
                () => Dot(
                  color: post.rate?.value == 2 || post.rate?.value == 3
                      ? Colors.yellowAccent
                      : AppColors.Slate_gray,
                  onPress: () async {
                    await homeController.addPostRating(post.id, 2, index);
                  },
                ),
              ),
              Expanded(
                child: Obx(
                  () => Divider(
                    thickness: 1,
                    color: post.rate?.value == 3
                        ? Colors.yellowAccent
                        : AppColors.Slate_gray,
                  ),
                ),
              ),
              Obx(
                () => Dot(
                  color: post.rate?.value == 3
                      ? Colors.yellowAccent
                      : AppColors.Slate_gray,
                  onPress: () async {
                    await homeController.addPostRating(post.id, 3, index);
                  },
                ),
              ),
              SizedBox(
                width: 25,
              ),
              // Expanded(
              //   child: Divider(
              //     thickness: 1,
              //     color: AppColors.Slate_gray,
              //   ),
              // ),
              // Dot(),
              // Expanded(
              //   child: Divider(
              //     thickness: 1,
              //     color: AppColors.Slate_gray,
              //   ),
              // ),
              // Dot(),
              // SizedBox(
              //   width: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     commentsBottomSheet(post: post);
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 8.0),
              //     child: Image.asset(
              //       AppImages.lock,
              //       color: AppColors.Slate_gray,
              //       height: 30,
              //     ),
              //   ),
              // )
            ],
          ),
          // Labels Row
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // AppText(
                //     text: AppStrings.Calling_it_BS,
                //     color: AppColors.Slate_gray,
                //     fontWeight: FontWeight.w400,
                //     fontSize: 8),
                // SizedBox(
                //   width: 2,
                // ),
                AppText(
                    text: "Wow",
                    color: AppColors.Slate_gray,
                    fontWeight: FontWeight.w400,
                    fontSize: 8),

                // SizedBox(
                //   width: 6,
                // ),
                AppText(
                  text: '     Up',
                  fontWeight: FontWeight.w400,
                  fontSize: 8,
                  color: AppColors.Slate_gray,
                ),
                // SizedBox(
                //   width: 40,
                // ),
                // AppText(
                //     text: AppStrings.l_ll_buy_that,
                //     fontWeight: FontWeight.w400,
                //     color: AppColors.Slate_gray,
                //     fontSize: 8),
                // SizedBox(
                //   width: 1,
                // ),
                AppText(
                  text: 'Awesome',
                  fontWeight: FontWeight.w400,
                  fontSize: 8,
                  color: AppColors.Slate_gray,
                ),
                // SizedBox(),
              ],
            ),
          ),
          // Lock Icon
        ],
      ),
    );
  }
}
