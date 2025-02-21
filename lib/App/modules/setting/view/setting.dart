import 'package:civitante/App/controller/controller_locate.dart';
import 'package:civitante/App/modules/bucket/view/bucket.dart';
import 'package:civitante/App/modules/profile/view/edit_profile.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../utilse/constant.dart';
import '../widget/devider.dart';
import '../widget/rowsection.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.settingController;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Get.back(); // Use GetX navigation
          },
        ),
        title: AppText(
          text: AppStrings.setting,
          fontWeight: FontWeight.w500,
          color: AppColors.appColor,
          fontSize: 20,
        ),
        centerTitle: false,
      ),
      body: Column(
        spacing: 14,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1,
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8, top: 8),
              child: Column(
                spacing: Get.height * 0.02,
                children: [
                  buildDivider(),
                  buildSectionRow(
                    title: AppStrings.Account,
                    trailing: AppText(
                      text: AppStrings.Active,
                      fontWeight: FontWeight.w400,
                      color: AppColors.green,
                      fontSize: 14,
                    ),
                  ),
                  buildDivider(),
                  buildSectionRow(
                    title: AppStrings.ID,
                    trailing: AppText(
                      text: AppStrings.Verified,
                      fontWeight: FontWeight.w400,
                      color: AppColors.moreblue,
                      fontSize: 14,
                    ),
                  ),
                  buildDivider(),
                  buildSectionRow(title: AppStrings.Privacy_and_safety),
                  buildDivider(),
                  buildSectionRow(
                      onTap: () {
                        Get.to(EditProfileScreen());
                      },
                      title: AppStrings.Edit_Profile),
                  // buildDivider(),
                  // buildSectionRow(
                  //     onTap: () {
                  //       Get.to(BucketScreen());
                  //     },
                  //     title: AppStrings.Bucket),
                  // buildDivider(),
                  // buildSectionRow(title: AppStrings.Notifications),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 8.0),
          //   child: _buildSectionHeader(title: AppStrings.General),
          // ),
          SizedBox(
            height: Get.height * 0.04,
          ),
          Card(
            elevation: 1,
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 1.0, left: 8, bottom: 8),
              child: Column(
                children: [
                  // buildDivider(),
                  // buildSectionRow(title: AppStrings.Display_and_sound),
                  // buildDivider(),
                  // buildSectionRow(
                  //   title: AppStrings.Light_Theme,
                  //   trailing: Obx(() => Switch(
                  //         value: controller.isLightTheme.value,
                  //         onChanged: (value) {
                  //           controller.isLightTheme.value =
                  //               value; // Update state
                  //         },
                  //       )),
                  // ),
                  // buildDivider(),
                  // buildSectionRow(title: AppStrings.Two_Factor_Authentication),
                  // buildDivider(),
                  buildSectionRow(
                    title: AppStrings.Logout,
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Image.asset(
                        AppImages.logout,
                        color: Colors.red,
                        height: 25,
                      ),
                    ),
                    // trailing: AppText(
                    //   text: AppStrings.Logout,
                    // ),
                    onTap: () {
                      PrefUtil.remove(PrefUtil.userId);
                      AppConstant().userID = null;
                      PrefUtil.remove(PrefUtil.userId);
                      Get.offAllNamed('/login');
                      Get.offAll(AppRoutes.login);
                    },
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: buildSectionRow(
                      title: "Delete Account",
                      leading: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete,color: AppColors.red_color,size: 24,),
                      ),

                      onTap: () {
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4), // Reduce the vertical padding for section headers
      child: AppText(
          text: title,
          color: AppColors.appColor,
          fontWeight: FontWeight.w500,
          fontSize: 18),
    );
  }
}
