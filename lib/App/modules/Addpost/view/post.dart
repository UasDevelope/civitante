import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';
import '../controller/post.dart';
import '../widgets/image_list.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.postController;
    final argument = Get.arguments;
    String communityId = argument != null && argument.containsKey("communityId")
        ? argument["communityId"]
        : "";
    log("Community id is $communityId");

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => LoadingOverlay(
            isLoading: controller.isloading.value,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 0.5, color: AppColors.Slate_gray),
                              ),
                              height: 40,
                              child: Center(
                                  child: AppText(
                                      text: AppStrings.Cancel,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          AppButton(
                            radius: 20,
                            height: 40,
                            textColor: AppColors.white,
                            color: AppColors.appColor,
                            width: Get.width / 5,
                            text: AppStrings.Post,
                            onPressed: () {
                              log("Community id is $communityId");
                              controller.addPost(communityId: communityId);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Image.asset(
                            AppImages.happend,
                            height: 30,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: controller.titleController,
                              decoration: InputDecoration(
                                hintText: AppStrings.Add_title,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              // Show dialog to choose between image and video
                              _showMediaPickerDialog(controller);
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(Icons.camera_alt),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButton<String>(
                              hint: const Text("Select a category"),
                              value: controller.selectCatagory.value,
                              items: controller.categories.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  controller.selectCatagory.value = value;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        height: 85,
                        width: 400,
                        child: ImageListView(),
                      ),
                      // Display selected video
                      SizedBox(height: 16),
                      TextField(
                        controller: controller.descController,
                        maxLines: 5,
                        minLines: 5,
                        decoration: InputDecoration(
                          hintText: AppStrings.Add_Desc,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.all(12),
                          isDense: false,
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: controller.tagController,
                          decoration: InputDecoration(
                            hintText: "Enter a tag",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty &&
                                !controller.tags.contains(value)) {
                              controller.tags.add(value);
                              controller.tagController.clear();
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16),

                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 3.0,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.tags.length,
                        itemBuilder: (context, index) {
                          final tag = controller.tags[index];
                          return Chip(
                            label: Text(tag),
                            deleteIcon: const Icon(Icons.cancel),
                            onDeleted: () {
                              controller.tags.removeAt(index);
                              setState(() {});
                            },
                          );
                        },
                      ),
                      if (communityId != "") ...[
                        SizedBox(height: 16),
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
                                  message:
                                      "Public: Visible to all\nPrivate: Hidden from non-members",
                                  child: Icon(Icons.info_outline,
                                      size: 16, color: AppColors.greyShade),
                                ),
                              ],
                            ),
                            Obx(
                              () => DropdownButton<String>(
                                value: controller.visibility.value.isEmpty
                                    ? null
                                    : controller.visibility.value,
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
                                onChanged: (value) {
                                  log("Visibility value is $value");
                                  controller.visibility.value = value!;
                                },
                                underline: SizedBox(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  // Dialog to choose between image and video
  void _showMediaPickerDialog(PostController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Media Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Pick Image"),
                onTap: () {
                  controller.pickImage();
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text("Pick Video"),
                onTap: () {
                  controller.pickVideo();
                  Get.back();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
