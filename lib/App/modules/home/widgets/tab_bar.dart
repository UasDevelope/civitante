import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../view/ramdomsized_posts.dart';

class HomeTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Obx(() => Container(
            height: 45,
            width: Get.width * 0.6, // Adjust width for better alignment
            decoration: BoxDecoration(
              color: Colors.grey.shade300, // Background track color
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                // Moving Indicator
                AnimatedAlign(
                  duration: Duration(milliseconds: 250),
                  alignment: homeController.isFollowing.value
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    width: (Get.width * 0.6) / 2, // Half of switch width
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildSwitchTab("Following", homeController, true),
                    _buildSwitchTab("Random", homeController, false),
                  ],
                ),
              ],
            ),
          )),
        ),
        Expanded(
          child: Obx(() => homeController.isFollowing.value
              ? RandomSizedPostsScreen(followed: true)
              : RandomSizedPostsScreen(randomized: true)),
        ),
      ],
    );
  }

  Widget _buildSwitchTab(String text, HomeController homeController, bool isForFollowing) {
    return Expanded(
      child: GestureDetector(
        onTap: homeController.toggleSwitchLane,
        child: Center(
          child: Obx(() {
            bool isSelected = homeController.isFollowing.value == isForFollowing;
            return AppText(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            );
          }),
        ),
      ),
    );
  }
}
