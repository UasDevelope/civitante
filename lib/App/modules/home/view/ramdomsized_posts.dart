import 'package:civitante/App/modules/home/widgets/filter_menues.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import '../widgets/engament_row.dart';
import '../widgets/slider_label.dart';

class RandomSizedPostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: HomeFilterMenues(
                onSelected: (value) {
                  print("selected=>$value");
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5, // Replace with your dynamic item count
                itemBuilder: (BuildContext context, int index) {
                  return CustomCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  AssetImage(AppImages.person), // Replace with your image
            ),
            title: AppText(
                text: "Sara Mathew", fontWeight: FontWeight.w500, fontSize: 16),
            trailing: PopupMenuButton(
              icon: Image.asset(
                AppImages.menue,
                height: 30,
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),   // Rounded corners
                  side: BorderSide(
                    color: AppColors.textFieldHintColor, // Border color
                    width: 0.4, // Border width
                  )),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: AppText(
                      text: AppStrings.Report,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Spread items evenly
                  children: [
                    // Views Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.view, // Replace with AppImages.view
                        height: 20,
                        color: AppColors.white, // Add custom color to the icon
                      ),
                      label: '25',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Likes Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.like, // Replace with AppImages.view
                        height: 15,
                        color: AppColors.white, // Add custom color to the icon
                      ),
                      label: '25',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Comments Row
                    buildStatItem(
                      icon: Image.asset(
                        AppImages.comment, // Replace with AppImages.view
                        height: 15,
                        color: AppColors.white,  // Add custom color to the icon
                      ),
                      label: '25',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(height: Get.height * 0.1, child: SliderWithLabels()),
        ],
      ),
    );
  }
}
