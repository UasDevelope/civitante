import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../Models/Post.dart';
import '../../../utilse/widgets.dart';
import 'comment.dart';
import 'dots.dart';

class SliderWithLabels extends StatelessWidget {
  final Post post;
  const SliderWithLabels({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider Row with dots
          Row(
            children: [
              Dot(),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: AppColors.Slate_gray,
                ),
              ),
              Dot(),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: AppColors.Slate_gray,
                ),
              ),
              Dot(),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: AppColors.Slate_gray,
                ),
              ),
              Dot(),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: AppColors.Slate_gray,
                ),
              ),
              Dot(),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  commentsBottomSheet(post: post);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    AppImages.lock,
                    color: AppColors.Slate_gray,
                    height: 30,
                  ),
                ),
              )
            ],
          ),
          // Labels Row
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppText(
                    text: AppStrings.Calling_it_BS,
                    color: AppColors.Slate_gray,
                    fontWeight: FontWeight.w400,
                    fontSize: 8),
                SizedBox(
                  width: 2,
                ),
                AppText(
                    text: "I'm not \nbuying this",
                    color: AppColors.Slate_gray,
                    fontWeight: FontWeight.w400,
                    fontSize: 8),
                SizedBox(
                  width: 5,
                ),
                AppText(
                  text: 'Zero',
                  fontWeight: FontWeight.w400,
                  fontSize: 8,
                  color: AppColors.Slate_gray,
                ),
                SizedBox(
                  width: 40,
                ),
                AppText(
                    text: AppStrings.l_ll_buy_that,
                    fontWeight: FontWeight.w400,
                    color: AppColors.Slate_gray,
                    fontSize: 8),
                SizedBox(
                  width: 1,
                ),
                AppText(
                  text: 'Love it',
                  fontWeight: FontWeight.w400,
                  fontSize: 8,
                  color: AppColors.Slate_gray,
                ),
                SizedBox(),
              ],
            ),
          ),
          // Lock Icon
        ],
      ),
    );
  }
}
