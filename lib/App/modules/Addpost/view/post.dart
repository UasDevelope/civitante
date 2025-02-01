import 'dart:io';

import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';
import '../widgets/image_list.dart'; // Ensure the path and imports are correct.

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.postController;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: AppText(text: AppStrings.Cancel),
                      ),
                      AppButton(
                          radius: 20,
                          height: 40,
                          textColor: AppColors.white,
                          color: AppColors.light_gray,
                          width: Get.width / 5,
                          text: AppStrings.Post,
                          onPressed: () {})
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        AppImages.happend,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller
                              .titleController, // Add this controller in your controller class
                          decoration: InputDecoration(
                            hintText: AppStrings.Add_title,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: TextStyle(
                            fontSize:
                                16, // Adjust to match your original text style
                          ),
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        AppImages.language,
                        height: 20,
                      ),
                      DropdownButton<String>(
                        value: controller.selectedLanguage.value,
                        items: controller.languages.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value != null) {
                            controller.selectedLanguage.value = value;
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: controller.tagController,
                      decoration: const InputDecoration(
                        hintText: "Enter a tag",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty &&
                            !controller.tags.contains(value)) {
                          setState(() {
                            controller.tags.add(value);
                          });
                          controller.tagController
                              .clear(); // Clear input after adding
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio:
                          3.0, // Adjust based on your chip dimensions
                    ),
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Prevents scrolling within the GridView
                    itemCount: controller.tags.length,
                    itemBuilder: (context, index) {
                      final tag = controller.tags[index];
                      return Chip(
                        label: Text(tag),
                        deleteIcon: const Icon(Icons.cancel),
                        onDeleted: () {
                          // Remove the tag
                          controller.tags.removeAt(index);
                          (context as Element)
                              .markNeedsBuild(); // Refresh the UI
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.pickImage();
                        },
                        child: Container(
                            height: 50,
                            width: 100,
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey, width: 1), // Border
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                            ),
                            child: Icon(Icons.camera_alt)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey, width: 1), // Border
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                        child: DropdownButton<String>(
                          hint: const Text(
                              "Select a category"), // Display hint text when no value is selected
                          value: controller.selectCatagory
                              .value, // Bind this to a variable in your state
                          items: controller.categories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              // Update the selected category
                              controller.selectCatagory.value = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 78,
                    width: 400,
                    //  width: 78,
                    child: ImageListView(),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
