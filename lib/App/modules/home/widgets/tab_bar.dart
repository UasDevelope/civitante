import 'dart:developer';

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

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: homeController.tabController,
            isScrollable: false,
            dividerColor: AppColors.white,
            indicator: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            tabs: [
             _buildTab("Following", 0)
              ,
             _buildTab("Random", 1) ,
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: homeController.tabController,
              children: [
                RandomSizedPostsScreen(followed: true),
                RandomSizedPostsScreen(randomized: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final homeController = Get.find<HomeController>();
    return   Obx((){
      bool isSelected=text==homeController.selectedTabValue.value;
      log("index is $index and selected is ${homeController.selectedTabIndex.value}");
      return Container(
        width: Get.width* 0.8, // Set a fixed width
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? Colors.black : Colors.transparent,
        ),
        child: Center( // Ensure text alignment stays consistent
          child: AppText(
            text: text,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: isSelected ? Colors.white : AppColors.appColor,
          ),
        ),
      );
    });

  }
}
