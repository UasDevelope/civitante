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

   AddCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title:  AppText(
              text: AppStrings.Add_Community,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.appColor,
            ),
            leading: IconButton(
              icon:  Icon(Icons.arrow_back, color: AppColors.appColor),
              onPressed: () => Get.back(),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding:  EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Community Image
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Obx(
                              () => GestureDetector(
                            onTap: () => ImageUtils.pickAndUpdateImage(controller.communityImage),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.greyShade, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: controller.communityImage.value.isNotEmpty
                                    ? NetworkImage(controller.communityImage.value)
                                    :  AssetImage(AppImages.person) as ImageProvider,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:  EdgeInsets.all(6),
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.appColor,
                          ),
                          child:  Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 8),
                   Center(
                    child: AppText(
                      text: "Tap to add a community image",
                      fontSize: 12,
                      color: AppColors.Slate_gray,
                    ),
                  ),
                   SizedBox(height: 24),

                  // Name Field
                   AppText(
                    text: "Community Name *",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.appColor,
                  ),
                   SizedBox(height: 8),
                  customTextFormField(
                    borderRadius: 12,
                    hintText: "Enter community name",
                    borderColor: AppColors.textFieldHintColor,
                    controller: controller.emailController,
                  ),
                   SizedBox(height: 16),

                  // Membership Dropdown
                  _buildDropdown(
                    label: "Membership Type",
                    tooltip: "Open: Anyone can join\nClosed: Requires approval\nPrivate: Invite only",
                    items: ['Open', 'Closed', 'Private'],
                    value: controller.membership,
                  ),
                   SizedBox(height: 16),

                  // Category Dropdown
                  _buildDropdown(
                    label: "Category",
                    tooltip: "Choose the main focus of your community",
                    items: ['Technology & Innovation',
                      'Business & Finance',
                      'General & Entertainment',
                      'Health & Wellness',
                      'Science & Education',
                      'Lifestyle & Self-Improvement',
                      'Politics & Society',
                      'Sports & Recreation',
                      'Art & Creativity',
                      'Food & Culinary',
                      'Automotive & Transport',
                      'Work & Careers',
                      'DIY & Home Improvement',
                      'Relationships & Social Life',
                      'Animals & Nature'],
                    value: controller.category,
                  ),
                   SizedBox(height: 16),

                  // Interest Dropdown
                  _buildDropdown(
                    label: "Interest",
                    tooltip: "Select a specific interest area",
                    items: [
                      'Artificial Intelligence',
                      'Cybersecurity',
                      'Blockchain & Cryptocurrency',
                      'Mental Health & Wellbeing',
                      'Personal Finance & Investing',
                      'Space Exploration',
                      'Sustainable Living',
                      'Fitness & Nutrition',
                      'Gaming & Esports',
                      'Photography & Videography',
                      'Travel & Adventure',
                      'Startups & Entrepreneurship',
                      'Psychology & Human Behavior',
                      'Fashion & Style',
                      'Music & Performing Arts'
                    ],
                    value: controller.interest,
                  ),
                   SizedBox(height: 16),

                  // Description Field
                   AppText(
                    text: "Description",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.appColor,
                  ),
                   SizedBox(height: 8),
                  customTextFormField(
                    maxLines: 3,
                    borderRadius: 12,
                    hintText: "Describe your community...",
                    borderColor: AppColors.textFieldHintColor,
                    controller: controller.descriptionController,
                  ),
                   SizedBox(height: 8),
                   AppText(
                    text: "Tell people what your community is about",
                    fontSize: 12,
                    color: AppColors.Slate_gray,
                  ),
                   SizedBox(height: 16),

                  // Visibility and Cost
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                           AppText(
                            text: AppStrings.Visibility,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.appColor,
                          ),
                           SizedBox(width: 8),
                          Tooltip(
                            message: "Public: Visible to all\nPrivate: Hidden from non-members",
                            child: Icon(Icons.info_outline, size: 16, color: AppColors.greyShade),
                          ),
                        ],
                      ),
                      Obx(
                            () => DropdownButton<String>(
                          value: controller.visibility.value.isEmpty ? null : controller.visibility.value,
                          items: ['Public', 'Private']
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: AppText(
                              text: e,
                              fontSize: 14,
                              color: AppColors.appColor,
                            ),
                          ))
                              .toList(),
                          onChanged: (value) => controller.visibility.value = value!,
                          underline:  SizedBox(),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                           AppText(
                            text: AppStrings.Cost,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.appColor,
                          ),
                           SizedBox(width: 8),
                          Tooltip(
                            message: "Points required to post in this community",
                            child: Icon(Icons.info_outline, size: 16, color: AppColors.greyShade),
                          ),
                        ],
                      ),
                       AppText(
                        text: '100 pts',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.appColor,
                      ),
                    ],
                  ),
                   SizedBox(height: 32),

                  // Submit Button
                  AppButton(
                    color: AppColors.appColor,
                    textColor: AppColors.white,
                    radius: 12,
                    text: AppStrings.Submit_Request,
                    onPressed: controller.addCommunity,
                    width: double.infinity,
                  ),
                   SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String tooltip,
    required List<String> items,
    required RxString value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              text: label,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.appColor,
            ),
             SizedBox(width: 8),
            Tooltip(
              message: tooltip,
              child: Icon(Icons.info_outline, size: 16, color: AppColors.greyShade),
            ),
          ],
        ),
         SizedBox(height: 8),
        Obx(
              () => DropdownButtonFormField<String>(
            value: items.contains(value.value) ? value.value : null,
            items: items
                .map((e) => DropdownMenuItem(
              value: e,
              child: AppText(
                text: e,
                fontSize: 14,
                color: AppColors.appColor,
              ),
            ))
                .toList(),
            onChanged: (newValue) => value.value = newValue!,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:  BorderSide(color: AppColors.greyShade),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:  BorderSide(color: AppColors.greyShade),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:  BorderSide(color: AppColors.appColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}