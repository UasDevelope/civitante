import 'package:civitante/App/modules/CommunityPost/controller/community_posts_controller.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/color.dart';
import '../../home/view/ramdomsized_posts.dart';

class CommunityPostScreen extends StatelessWidget {
  CommunityPostScreen({super.key});

  CommunityPostController controller = Get.put(CommunityPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(AppImages.person),
            ),
            SizedBox(
              width: 8,
            ),
            AppText(
                text: "Tremblay and Sons",
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w500)
          ],
        ),
      ),
      backgroundColor: Colors.white, // Change the background color
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            //   child: CustomCard(
            //     haveComments: true,
            //   ),
            // ),
            SizedBox(
              height: Get.height * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}
