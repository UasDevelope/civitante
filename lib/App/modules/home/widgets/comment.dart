import 'dart:developer';

import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/strings.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../shared/app_button.dart';
import '../../../shared/color.dart';

Future commentsBottomSheet({String postId = ""}) {
  final postDetailController = LocateController.postDetailController;

  final TextEditingController commentController = TextEditingController();

  final List<String> comments = [
    "Interesting Nicola that not one reply or tag on this #UX talent shoutout in the last 24 hours since your tweet here......🤔",
    "Maybe I forgot the hashtags. #hiringux #designjobs #sydneyux #sydneydesigners #uxjobs",
  ];
  log("Post Id is $postId");

  return Get.bottomSheet(
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          margin: EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 16),
              // Comments List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          CircleAvatar(
                            backgroundImage: AssetImage(AppImages.person),
                            radius: 20,
                          ),
                          SizedBox(width: 10),
                          // Comment Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      index == 0 ? "kiero_d" : "karennne",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "· 2d",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  comments[index],
                                  style: TextStyle(fontSize: 14),
                                ),
                                if (index == 0)
                                  Row(
                                    children: [
                                      Icon(Icons.thumb_up,
                                          size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text("25",
                                          style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 16),
                                      Icon(Icons.comment,
                                          size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text("25",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Divider(thickness: 1, color: Colors.grey[300]),
              // Add Comment Section
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: postDetailController.commentController,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      if (postDetailController
                          .commentController.text.isNotEmpty) {
                        await postDetailController.addComments(postId);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
  );
}
