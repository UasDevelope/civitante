import 'package:civitante/App/controller/controller_locate.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AllCommunitiesList.dart';

class AllCommunitiesTabBar extends StatelessWidget {
  const AllCommunitiesTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.allCommunity;
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: TabBar(
              physics: NeverScrollableScrollPhysics(),
              controller: controller.tabController,
              isScrollable: false,
              tabAlignment: TabAlignment.center,
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
                _buildTab("New", 0),
                _buildTab("Top communities", 1),
                _buildTab("Joined", 2),
                // _buildTab("Trending", 3),
                // _buildTab("Dev Recommendations", 4),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                MyCommunitiesList(),
                MyCommunitiesList(),
                MyCommunitiesList(),
                // MyCommunitiesList(),
                // MyCommunitiesList(),
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
        final controller = LocateController.allCommunity;
        return Obx(() {
          bool isSelected = controller.selectedTabIndex.value == index;
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
        });
      },
    );
  }
}
