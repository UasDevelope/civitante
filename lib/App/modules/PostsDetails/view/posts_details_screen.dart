import 'dart:developer';

import 'package:civitante/App/Models/Post.dart';
import 'package:civitante/App/modules/PostsDetails/controller/posts_details_controller.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import '../../home/view/ramdomsized_posts.dart';
import '../../notification/view/notification.dart';

class PostsDetailsScreen extends StatelessWidget {
  PostsDetailsController controller = Get.put(PostsDetailsController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final post = arguments["data"] as Post;
    final currentUser = arguments["currentUser"] as bool;
    log("Posts title is ${post.title}$currentUser");
    return Scaffold(
      backgroundColor: Colors.white, // Change the background color
      appBar: HomeAppbar(
        title: "Bangalore",
        imagePath: AppImages.location, // Optional, can be null
        rightIcon: AppImages.notification,
        onRightIconPressed: () {
          Get.to(NotificationsScreen());
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15, right: 15),
            //   child: HomeSerchField(
            //     hintText: "Search here...", // Custom hint text
            //     onChanged: (value) {
            //       print("Search value: $value"); // Handle text changes
            //     },
            //   ),
            // ),
            // SizedBox(
            //   height: Get.height * 0.02,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            //   child: Card(
            //     color: AppColors.white,
            //     child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Like 15 videos",
            //             style: GoogleFonts.poppins(
            //                 fontSize: 14, color: AppColors.appColor),
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 "75/300",
            //                 style: GoogleFonts.poppins(
            //                     fontSize: 11, color: AppColors.Slate_gray),
            //               ),
            //               Text(
            //                 "12 pts",
            //                 style: GoogleFonts.poppins(
            //                     fontSize: 11,
            //                     color: AppColors.blue,
            //                     fontWeight: FontWeight.w600),
            //               ),
            //             ],
            //           ),
            //           SizedBox(
            //             height: 8,
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Expanded(
            //                 child: LinearProgressIndicator(
            //                   value: 0.6,
            //                   backgroundColor: Colors.grey[300],
            //                   color: Colors.blue,
            //                 ),
            //               ),
            //               SizedBox(width: 10),
            //               Text(
            //                 '${(0.6 * 100).toInt()}%',
            //                 style: GoogleFonts.poppins(
            //                     fontSize: 12, color: AppColors.appColor),
            //               ),
            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomCard2(
                post: post,
                currentUser: currentUser,
                haveComments: true,
              ),
            ),
            SizedBox(
              height: Get.height * 0.06,
            ),
          ],
        ),
      ),

    );
  }
}
