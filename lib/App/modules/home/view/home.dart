import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';
import '../../notification/view/notification.dart';
import '../controller/home_controller.dart';

import '../widgets/tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    homeController.fetchAndAssignPosts(
        followed: true, randomized: false, communityId: '');
    return Scaffold(
      backgroundColor: Colors.white, // Change the background color
      appBar: HomeAppbar(
        backButton: false,
        title: "Bangalore",
        imagePath: AppImages.location, // Optional, can be null
        rightIcon: AppImages.notification,
        onRightIconPressed: () {
          Get.to(NotificationsScreen());
        },
      ),
      // drawer: CustomDrawer(), // Add the drawer here
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
              height: Get.height / 1.32, child: HomeTabBar()),
        ],
      ),
    );
  }
}
