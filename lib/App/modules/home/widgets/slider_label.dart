import 'dart:developer';
import 'dart:io';

import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/toast_util.dart';
import 'package:flutter/material.dart';

import '../../../Models/Post.dart';
import '../../../utilse/widgets.dart';
import '../controller/home_controller.dart';
import 'comment.dart';
import 'dots.dart';

class SliderWithLabels extends StatelessWidget {
  final Post post;
  const SliderWithLabels({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    // Move initialization outside the build method
    if (homeController.newRate.value != post.rate.value) {
      Future.microtask(() {
        homeController.newRate.value = post.rate.value;
      });
    }

    return Obx(
          () => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Slider Row with dots
            Row(
              children: [
                const SizedBox(width: 5),
                Dot(
                  color: homeController.newRate.value >= 1
                      ? Colors.yellowAccent
                      : AppColors.Slate_gray,
                  onPress: () async {
                    var response = await HttpService.post(
                        '/ratePost/${post.id}', {"rate": 1});
                    homeController.newRate.value = response["rate"] ?? 0;
                    ToastUtil.showToast(
                        message: "Rated successfully with rate: Wow");
                  },
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: homeController.newRate.value >= 2
                        ? Colors.yellowAccent
                        : AppColors.Slate_gray,
                  ),
                ),
                Dot(
                  color: homeController.newRate.value >= 2
                      ? Colors.yellowAccent
                      : AppColors.Slate_gray,
                  onPress: () async {
                    var response = await HttpService.post(
                        '/ratePost/${post.id}', {"rate": 2});
                    homeController.newRate.value = response["rate"] ?? 0;
                    ToastUtil.showToast(
                        message: "Rated successfully with rate: Up");
                  },
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: homeController.newRate.value == 3
                        ? Colors.yellowAccent
                        : AppColors.Slate_gray,
                  ),
                ),
                Dot(
                  color: homeController.newRate.value == 3
                      ? Colors.yellowAccent
                      : AppColors.Slate_gray,
                  onPress: () async {
                    var response = await HttpService.post(
                        '/ratePost/${post.id}', {"rate": 3});
                    homeController.newRate.value = response["rate"] ?? 0;
                    ToastUtil.showToast(
                        message: "Rated successfully with rate: Awesome");
                  },
                ),
                const SizedBox(width: 25),
              ],
            ),
            // Labels Row
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Wow",
                    color: AppColors.Slate_gray,
                    fontWeight: FontWeight.w400,
                    fontSize: 8,
                  ),
                  AppText(
                    text: 'Up',
                    fontWeight: FontWeight.w400,
                    fontSize: 8,
                    color: AppColors.Slate_gray,
                  ),
                  AppText(
                    text: 'Awesome',
                    fontWeight: FontWeight.w400,
                    fontSize: 8,
                    color: AppColors.Slate_gray,
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

