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
    log("Posts title is ${post.title}");
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
                haveComments: true,
              ),
            ),
            SizedBox(
              height: Get.height * 0.06,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: controller.commentController,
                  placeholder: "Write a comment...",
                  placeholderStyle: TextStyle(
                    color: CupertinoColors.placeholderText.resolveFrom(context),
                    fontSize: 16,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemBackground
                        .resolveFrom(context),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: CupertinoColors.systemGrey5.resolveFrom(context),
                      width: 1,
                    ),
                  ),
                  suffix: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.commentController,
                    builder: (context, value, _) {
                      return AnimatedOpacity(
                        opacity: value.text.isNotEmpty ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: () {
                            controller.commentController.clear();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              CupertinoIcons.xmark_circle_fill,
                              color: CupertinoColors.systemGrey
                                  .resolveFrom(context),
                              size: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller.commentController,
                builder: (context, value, _) {
                  return AnimatedScale(
                    scale: value.text.isNotEmpty ? 1 : 0.85,
                    duration: const Duration(milliseconds: 200),
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(12),
                      borderRadius: BorderRadius.circular(25),
                      minSize: 0,
                      color: value.text.isNotEmpty
                          ? CupertinoColors.systemBlue
                          : CupertinoColors.systemGrey4,
                      onPressed: value.text.isNotEmpty
                          ? () async {
                              // final newComment = Comment(
                              //   id: UniqueKey().toString(), // Generate a unique ID
                              //   user: User(id: id, name: name), // Pass the current user
                              //   text: text, // The comment text
                              //   likes: [], // Initialize an empty likes list
                              //   createdAt: DateTime.now(), // Current timestamp
                              //   replies: [], // Initialize an empty replies list
                              // );
                              await controller.addComments(post.id);
                            }
                          : null,
                      child: Icon(
                        CupertinoIcons.arrow_up_circle_fill,
                        color: CupertinoColors.white,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
