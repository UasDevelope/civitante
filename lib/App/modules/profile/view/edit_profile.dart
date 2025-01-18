import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: AppText(text:
          AppStrings.Edit_Profile,
          fontWeight:FontWeight.w500,
          color:AppColors.appColor,
          fontSize:14
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture with Camera Icon
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage(AppImages.person), // Replace with actual image
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Username/Email Text Field
            customTextFormField(
                validatore: (value) {
                  return Validators.emailValidator(value!);
                },
                width: Get.width / 2,
                borderRadius: 25,
                hintText: AppStrings.enterUsernameEmail,
                borderColor: AppColors.textFieldHintColor,
                controller:TextEditingController()),
            SizedBox(height: 16),
            // Location Text Field
            customTextFormField(
                validatore: (value) {
                  return Validators.locationValidator(value!);
                },
                width: Get.width / 2,
                borderRadius: 25,
                hintText: AppStrings.location,
                borderColor: AppColors.textFieldHintColor,
                controller: TextEditingController()),
            SizedBox(height: 16),
            // Info Text
            Align(
              alignment: Alignment.centerLeft,
              child: AppText(text:
                "Points for the deduction if someone wants to follow",
               color:AppColors.Slate_gray,
                fontWeight:FontWeight.w400,
                fontSize:14
              ),
            ),
            SizedBox(height: 20),
            // Follow Cost Text Field
            customTextFormField(
                validatore: (value) {
                  return Validators.locationValidator(value!);
                },
                width: Get.width / 2,
                borderRadius: 25,
                hintText: AppStrings.Follow_cost,
                borderColor: AppColors.textFieldHintColor,
                controller: TextEditingController()),
            Spacer(),
            // Save Changes Button
            AppButton(
                textColor:AppColors.white,
                radius:20,
                text: AppStrings.Save_Changes, onPressed: (){}),
            SizedBox(height:20,),
          ],
        ),
      ),
    );
  }
}
