import 'dart:io';

import 'package:civitante/App/controller/controller_locate.dart';
import 'package:civitante/App/shared/app_button.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:civitante/App/utilse/uploadImage.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/app_textform_field.dart';
import '../../../shared/validators.dart';

class AddCommunityScreen extends StatelessWidget {
  final controller = LocateController.addCommunityController;
  @override
  Widget build(BuildContext context) {
    return Obx(() => LoadingOverlay(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              title: AppText(
                  text: AppStrings.Add_Community,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.appColor),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Obx(() => InkWell(
                                onTap: () {
                                  ImageUtils.pickAndUpdateImage(
                                      controller.communityImage);
                                },
                                splashColor: Colors.transparent,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      controller.communityImage.value.isNotEmpty
                                          ? NetworkImage(
                                              controller.communityImage.value)
                                          : AssetImage(AppImages.person)
                                              as ImageProvider,
                                ),
                              )),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.black),
                              onPressed: () {
                                // Add image picking logic here
                                controller.communityImage.value =
                                    'https://via.placeholder.com/150';
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    customTextFormField(
                      validatore: (value) {
                        return Validators.emailValidator(value!);
                      },
                      width: Get.width / 2,
                      borderRadius: 25,
                      hintText: "Enter Community Name",
                      borderColor: AppColors.textFieldHintColor,
                      controller: controller.emailController,
                    ),
                    SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Select membership',
                      items: ['Open', 'Closed', 'Private'],
                      onChanged: (value) =>
                          controller.membership.value = value!,
                    ),
                    SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Select Category',
                      items: ['Technology', 'Health', 'Education'],
                      onChanged: (value) => controller.category.value = value!,
                    ),
                    SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Select Interest',
                      items: ['AI', 'Sports', 'Music'],
                      onChanged: (value) => controller.interest.value = value!,
                    ),
                    SizedBox(height: 16),
                    customTextFormField(
                      maxLines: 3,
                      width: Get.width / 2,
                      borderRadius: 25,
                      hintText: "Enter Description",
                      borderColor: AppColors.textFieldHintColor,
                      controller: controller.descriptionController,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                            text: AppStrings.Visibility,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appColor),
                        Obx(
                          () => DropdownButton<String>(
                            dropdownColor: AppColors.white,
                            value: controller.visibility.value.isEmpty
                                ? null
                                : controller.visibility.value,
                            hint: Icon(Icons.language),
                            items: ['Public', 'Private']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: AppText(
                                          text: e,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: AppColors.appColor),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              controller.visibility.value = value!;
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                            text: AppStrings.Cost,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appColor),
                        AppText(
                            text: 'pts 100',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appColor),
                      ],
                    ),
                    SizedBox(height: 32),
                    AppButton(
                        color: AppColors.appColor,
                        textColor: AppColors.white,
                        radius: 25,
                        text: AppStrings.Submit_Request,
                        onPressed: () {
                          controller.addCommunity();
                        }),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildTextField(String hintText, {int maxLines = 1}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
            text: label,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.appColor),
        SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
              dropdownColor: AppColors.white,
              value: items.contains(controller.membership.value)
                  ? controller.membership.value
                  : null,
              items: items
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: AppText(
                            text: e,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.appColor),
                      ))
                  .toList(),
              onChanged: onChanged,
              focusColor: AppColors.textFiledBorderColor,
              focusNode: FocusNode(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Circular border
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Grey border
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Grey border
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              borderRadius:
                  BorderRadius.circular(20.0), // Dropdown's internal border
            )),
      ],
    );
  }
}
