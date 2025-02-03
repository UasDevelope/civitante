import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';

import '../view/ramdomsized_posts.dart';

class HomeTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: AppColors.white,
            indicator: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white, // Text color for the active tab
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero, // Remove additional padding
            tabs: [
              _buildTab("Pro Accounts", 0),
              _buildTab("Followed Accounts", 1),
              _buildTab("Randomized Posts", 2),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                RandomSizedPostsScreen(),
                RandomSizedPostsScreen(),
                RandomSizedPostsScreen(),
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
        final TabController tabController = DefaultTabController.of(context)!;
        return AnimatedBuilder(
          animation: tabController,
          builder: (context, child) {
            final bool isSelected = tabController.index == index;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin:
                  EdgeInsets.symmetric(horizontal: 8), // Spacing between tabs
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ), // Border for each tab
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: AppText(
                text: text,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : AppColors.appColor,
              ),
            );
          },
        );
      },
    );
  }
}
