import 'package:civitante/App/Models/my_community_model.dart';
import 'package:civitante/App/modules/editMyCommunity/controller/editCommunityController.dart';
import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/shared/app_button.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:civitante/App/utilse/uploadImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/app_textform_field.dart';
import '../../../shared/validators.dart';

class EditCommunityScreen extends StatelessWidget {
  const EditCommunityScreen();
  @override
  Widget build(BuildContext context) {
    final data = Get.arguments["data"] as MyCommunityModel;
    final controller = Get.find<EditCommunityController>();
    controller.assignValue(
        name: data.name,
        image: data.image,
        category: data.category,
        desc: data.description);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(title: AppStrings.Edit_Community),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Obx(() => GestureDetector(
                          onTap: () async {
                            await ImageUtils.pickAndUpdateImage(
                                controller.imageUrl);
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(controller.imageUrl.value),
                          ),
                        )),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    ImageUtils.pickAndUpdateImage(controller.imageUrl);
                  },
                  child: Image.asset(
                    AppImages.camera,
                    height: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            customTextFormField(
              validatore: (value) {
                // return Validators.emailValidator(value!);
              },
              width: Get.width / 2,
              borderRadius: 25,
              hintText: AppStrings.Enter_Community_Name,
              borderColor: AppColors.textFieldHintColor,
              controller: controller.communityNameController,
            ),
            SizedBox(height: 15),
            Obx(() => DropdownButtonFormField<String>(
                  dropdownColor: AppColors.white,
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Circular border
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

                  items: controller.categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedCategory.value = value!;
                  },
                )),
            SizedBox(height: 15),
            customTextFormField(
              maxLines: 4,
              validatore: (value) {
                // return Validators.emailValidator(value!);
              },
              width: Get.width / 2,
              borderRadius: 15,
              hintText: AppStrings.Enter_Description,
              borderColor: AppColors.textFieldHintColor,
              controller: controller.descriptionController,
            ),
            Spacer(),
            AppButton(
                color: AppColors.red_color,
                textColor: AppColors.white,
                radius: 15,
                text: AppStrings.Delete,
                onPressed: () {
                  controller.deleteCommunity(data.id);
                }),
            SizedBox(height: 10),
            AppButton(
                color: AppColors.appColor,
                textColor: AppColors.white,
                radius: 15,
                text: AppStrings.Save_Changes,
                onPressed: () {
                  controller.saveChanges(data.id);
                }),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
