import 'package:flutter/material.dart';

import '../../../utilse/location_controller.dart';
import '../../../utilse/widgets.dart';
import '../../notification/view/notification.dart';
import '../controller/home_controller.dart';

import '../widgets/tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    LocationController locationController = Get.put(LocationController());
    homeController.fetchAndAssignPosts(
        followed: true, randomized: false, communityId: '');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppbar(
        backButton: false,

        title: "Bangalore",
        imagePath: AppImages.location, // Optional, can be null
        rightIcon: AppImages.notification,
        onRightIconPressed1: () {
          Get.to(NotificationsScreen());
        },
      ),
      // drawer: CustomDrawer(), // Add the drawer here
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.zero,
                height: Get.height / 1.32, child: Center(child: HomeTabBar())),
          ),
        ],
      ),
    );
  }
}