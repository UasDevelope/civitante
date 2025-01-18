import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';
import '../../notification/view/notification.dart';
import '../widgets/home_search.dart';
import '../widgets/tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change the background color
      appBar: HomeAppbar(
        title: "Bangalore",
        imagePath: AppImages.location, // Optional, can be null
        rightIcon: AppImages.notification,
        onRightIconPressed: () {
          Get.to(NotificationsScreen());
        },
      ),
      drawer: CustomDrawer(), // Add the drawer here
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: HomeSerchField(
              hintText: "Search here...", // Custom hint text
              onChanged: (value) {
                print("Search value: $value"); // Handle text changes
              },
            ),
          ),
          SizedBox(
            height: Get.height * 0.05,
          ),
          Container(height: Get.height / 1.7, child: HomeTabBar()),
        ],
      ),
    );
  }
}
