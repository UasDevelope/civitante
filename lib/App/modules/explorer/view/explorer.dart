import 'package:civitante/App/modules/home/widgets/home_search.dart';
import 'package:civitante/App/modules/notification/view/notification.dart';
import 'package:flutter/material.dart';
import '../../../utilse/widgets.dart';
import '../../home/view/ramdomsized_posts.dart';

class ExplorerScreen extends StatelessWidget {
  ExplorerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(
        backButton: false,
        title: AppStrings.Explore,
        imagePath: AppImages.location, // Optional, can be null
        rightIcon: AppImages.notification,
        onRightIconPressed1: () {
          Get.to(NotificationsScreen());
        },
      ),
      body: RandomSizedPostsScreen(
        explore: true,
      ),
     // drawer: CustomDrawer(),
    );
  }
}
