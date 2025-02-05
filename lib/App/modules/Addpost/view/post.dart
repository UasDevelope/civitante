import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../utilse/widgets.dart';
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
                            color: AppColors.appColor,
                            width: Get.width / 5,
                            text: AppStrings.Post,
                            onPressed: () {
                              log("Community id is $communityId");
                              controller.addPost(communityId: communityId);
                            })
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
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: TextField(
                        controller: controller.descController,
                        maxLines: 10, // Show 10 lines by default
                        minLines: 10, // Force 10-line height
                        decoration: InputDecoration(
                          hintText: AppStrings.Add_Desc,
                          // Border styling
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Optional: slight rounding
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.all(
                              12), // Add padding for text alignment
                          isDense:
                              false, // Disable "dense" mode for proper multi-line height
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 16),
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
                              !controller.tags!.contains(value)) {
                            setState(() {
                              controller.tags!.add(value);
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
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
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
            ),
          )),
    );
  }
}
