import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ensure GetX is imported
import '../../../utilse/widgets.dart';
import '../../bottom/view/bottom_nav.dart';
import '../widget/menue.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.drawerController;
    final profileController = LocateController.profileController;
    profileController.fetchAndAssignPosts();
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Arrow on top
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50.0, // Adjusted for positioning the arrow
                left: 15,
              ),
              child: GestureDetector(
                onTap: () {
                  // Get.to(BottomNavScreen());
                  Get.back(); // Close the drawer when tapping the arrow
                },
                child: Image.asset(
                  AppImages.arrowback,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          // User account section (custom layout)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(profileController.imageUrl.value),
                    ),
                    SizedBox(width: 12), // Space between image and text

                    // Account Details in a Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: "Bonjour",
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textFieldHintColor),
                        Obx(() => AppText(
                              text: profileController.name.value,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.appColor,
                            )),
                      ],
                    ),
                  ],
                )),
          ),
          Divider(
            color: AppColors.textFieldHintColor,
            thickness: 0.5,
          ),
          SizedBox(height: 20),

          // Reusing MenuItem widget for navigation
          MenuItem(
            imageColor: AppColors.appColor,
            imagePath: AppImages.mycommunity,
            title: AppStrings.my_communities,
            routeName: AppRoutes.myCommunity,
          ),
          MenuItem(
            imageColor: AppColors.appColor,
            imagePath: AppImages.community,
            title: AppStrings.communities,
            routeName: AppRoutes.Allcommunities,
          ),
          MenuItem(
            imageColor: AppColors.appColor,
            imagePath: AppImages.contactAdmin,
            title: AppStrings.contact_admin,
            routeName: AppRoutes.contactAdmin,
          ),
          MenuItem(
            imageColor: AppColors.appColor,
            imagePath: AppImages.setting,
            title: AppStrings.setting,
            routeName: AppRoutes.setting,
          ),
          MenuItem(
            imageColor: AppColors.appColor,
            imagePath: AppImages.fqa,
            title: AppStrings.fqa,
            routeName: AppRoutes.fqa,
          ),
          Spacer(),

          /// Logout button

          MenuItem(
            imageColor: Color(0xffFF3B30),
            imagePath: AppImages.logout,
            title: AppStrings.log_out,
            routeName: AppRoutes.login,
          ),
        ],
      ),
    );
  }
}
