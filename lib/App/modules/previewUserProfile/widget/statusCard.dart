import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class StatsContainer extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final Color percentageColor;
  final VoidCallback voidCallback;

  StatsContainer({
    required  this.voidCallback,
    required this.title,
    required this.value,
    required this.percentage,
    required this.percentageColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:voidCallback,
      child: Container(
        height: 80,
        child: Card(
          color:AppColors.white,
          elevation:0.4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                    text: title,
                    fontWeight: FontWeight.w800,
                    color: AppColors.Slate_gray,
                    fontSize: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppText(
                        text: value,
                        fontWeight: FontWeight.w800,
                        color: AppColors.Slate_gray,
                        fontSize: 12),
                    Spacer(),
                    // Up Arrow Icon
                    Image.asset(
                      AppImages.arrowup,
                      height: 20,
                      width: 20,
                      color: AppColors.moreblue, // GreenAccent for positive change

                      fit: BoxFit.contain,
                    ),
                    // Percentage Change
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: AppText(
                        text: "10.2%",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color:
                        AppColors.moreblue, // GreenAccent for positive change
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
