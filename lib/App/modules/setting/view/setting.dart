import 'package:civitante/App/modules/profile/view/edit_profile.dart';
import 'package:civitante/App/service/auth_services.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../service/http_service.dart';
import '../../../utilse/constant.dart';
import '../../../utilse/toast_util.dart';
import '../widget/devider.dart';
import '../widget/rowsection.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.settingController;
    final String userID = Get.arguments.toString();
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: isTablet ? 36 : 30,
          ),
          onPressed: () => Get.back(),
        ),
        title: AppText(
          text: AppStrings.setting,
          fontWeight: FontWeight.w500,
          color: AppColors.appColor,
          fontSize: isTablet ? 24 : 20,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 20 : 8,
                    horizontal: isTablet ? 16 : 8,
                  ),
                  child: Column(
                    children: [
                      buildDivider(),
                      buildSectionRow(
                        title: AppStrings.Account,
                        trailing: AppText(
                          text: AppStrings.Active,
                          fontWeight: FontWeight.w400,
                          color: AppColors.green,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      buildDivider(),
                      buildSectionRow(
                        title: AppStrings.ID,
                        trailing: AppText(
                          text: AppStrings.Verified,
                          fontWeight: FontWeight.w400,
                          color: AppColors.moreblue,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      buildDivider(),
                      buildSectionRow(
                        title: AppStrings.Privacy_and_safety,
                      ),
                      buildDivider(),
                      buildSectionRow(
                        onTap: () => Get.to(EditProfileScreen()),
                        title: AppStrings.Edit_Profile,
                      ),
                      buildDivider(),
                      buildSectionRow(
                        onTap: () {},
                        title: "Manage My Communities",
                      ),
                      buildDivider(),
                      buildSectionRow(
                        title: AppStrings.Logout,
                        leading: Padding(
                          padding: EdgeInsets.only(right: isTablet ? 24 : 20),
                          child: Image.asset(
                            AppImages.logout,
                            color: Colors.red,
                            height: isTablet ? 30 : 25,
                          ),
                        ),
                        onTap: () {
                          PrefUtil.remove(PrefUtil.userId);
                          AppConstant().userID = null;
                          Get.offAllNamed('/login');
                        },
                      ),
                      buildDivider(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                        child: InkWell(
                          onTap: () async {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            User? user = auth.currentUser;
                            if (user != null &&
                                user.providerData
                                    .any((p) => p.providerId == 'google.com')) {
                              await AuthServices().deleteAccount();
                              final response =
                                  await HttpService.delete("/deleteAccount");
                              if (response is Map &&
                                  response.containsKey('error')) {
                                ToastUtil.showToast(
                                  message: "Error: ${response['error']}",
                                  backgroundColor: Colors.red,
                                );
                              } else {
                                ToastUtil.showToast(
                                  message: "Account deleted Successfully",
                                  backgroundColor: Colors.green,
                                );
                                Get.offAllNamed('/login');
                                AppConstant().userID = '';
                              }
                            } else {
                              final response =
                                  await HttpService.delete("/deleteAccount");
                              if (response is Map &&
                                  response.containsKey('error')) {
                                ToastUtil.showToast(
                                  message: "Error: ${response['error']}",
                                  backgroundColor: Colors.red,
                                );
                              } else {
                                ToastUtil.showToast(
                                  message: "Account deleted Successfully",
                                  backgroundColor: Colors.green,
                                );
                                Get.offAllNamed('/login');
                                AppConstant().userID = '';
                              }
                            }
                          },
                          child: Center(
                            child: AppText(
                              text: "Delete Account",
                              fontWeight: FontWeight.w500,
                              fontSize: isTablet ? 18 : 16,
                              color: AppColors.red_color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 24 : 16),
            ],
          ),
        ),
      ),
    );
  }
}
