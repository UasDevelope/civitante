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
      length: 2, // Correct number of tabs
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            physics: NeverScrollableScrollPhysics(),
            isScrollable: false,
            dividerColor: AppColors.white,
            indicator: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            onTap: (index) {
              if (index == 0) {
                homeController.fetchAndAssignPosts(followed: true);
              } else {
                homeController.fetchAndAssignPosts(randomized: true);
              }
            },
            tabs: [
              _buildTab("Following", 0),
              _buildTab("Random", 1),
            ],
          ),
          Expanded(
            child: TabBarView(
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
    return Builder(
      builder: (context) {
        final TabController tabController = DefaultTabController.of(context);
        return AnimatedBuilder(
          animation: tabController,
          builder: (context, child) {
            final bool isSelected = tabController.index == index;

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
          },
        );
      },
    );

  }
}
