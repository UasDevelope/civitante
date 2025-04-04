import 'package:civitante/App/utilse/uploadImage.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.profileController;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black, size: isTablet ? 30 : 24),
          onPressed: () => Get.back(),
        ),
        title: AppText(
          text: AppStrings.Edit_Profile,
          fontWeight: FontWeight.w500,
          color: AppColors.appColor,
          fontSize: isTablet ? 20 : 14,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              Stack(
                alignment: Alignment.center,
                children: [
                  Obx(
                    () => InkWell(
                      onTap: () =>
                          ImageUtils.pickAndUpdateImage(controller.imageUrl),
                      child: CircleAvatar(
                        radius: isTablet ? 70 : 50,
                        backgroundImage: controller.imageUrl.isEmpty
                            ? AssetImage(AppImages.person)
                            : NetworkImage(controller.imageUrl.value)
                                as ImageProvider,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: isTablet ? 25 : 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: isTablet ? 28 : 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 32 : 24),

              // Form Section
              Container(
                width: isTablet ? Get.width * 0.6 : Get.width,
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    AppText(
                      text: "Name",
                      fontSize: isTablet ? 18 : 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appColor,
                    ),
                    SizedBox(height: 8),
                    customTextFormField(
                      width: double.infinity,
                      borderRadius: 25,
                      hintText: "Enter your name",
                      borderColor: AppColors.textFieldHintColor,
                      controller: controller.nameController,
                    ),
                    SizedBox(height: isTablet ? 24 : 16),

                    // Info Section
                    Container(
                      padding: EdgeInsets.all(isTablet ? 16 : 12),
                      decoration: BoxDecoration(
                        color: AppColors.light_gray.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Profile Info",
                            fontSize: isTablet ? 18 : 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appColor,
                          ),
                          SizedBox(height: 8),
                          AppText(
                            text:
                                "Set the number of points users must deduct to follow you. This helps control your audience and rewards engagement.",
                            fontSize: isTablet ? 16 : 12,
                            color: AppColors.Slate_gray,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 16),

                    // Follow Cost Field
                    AppText(
                      text: "Follow Cost (Points)",
                      fontSize: isTablet ? 18 : 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appColor,
                    ),
                    SizedBox(height: 8),
                    customTextFormField(
                      keyboardType: TextInputType.number,
                      validatore: (value) {},
                      width: double.infinity,
                      borderRadius: 25,
                      hintText: AppStrings.Follow_cost,
                      borderColor: AppColors.textFieldHintColor,
                      controller: controller.costController,
                    ),
                  ],
                ),
              ),

              SizedBox(height: isTablet ? 40 : 32),

              // Save Button
              Obx(
                () => AppButton(
                  textColor: AppColors.white,
                  radius: 20,
                  width: isTablet ? Get.width * 0.4 : Get.width * 0.8,
                  height: isTablet ? 60 : 50,
                  color: AppColors.appColor,
                  text: controller.isLoading.value
                      ? "Updating..."
                      : AppStrings.Save_Changes,
                  onPressed: () => controller.editProfile(),
                ),
              ),
              SizedBox(height: isTablet ? 40 : 20),
            ],
          ),
        ),
      ),
    );
  }
}
