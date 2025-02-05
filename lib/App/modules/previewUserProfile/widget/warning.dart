import 'package:flutter/material.dart';

import '../../../utilse/widgets.dart';

class Warning extends StatelessWidget {
  const Warning({super.key});

  @override
  Widget build(BuildContext context) {
    return     Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade300,
        borderRadius: BorderRadius.circular(8), // Added rounded corners
      ),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Ensures the container size adjusts to its content
        crossAxisAlignment:
        CrossAxisAlignment.start, // Aligns content to the start
        children: [
          // Warning icon
          Row(
            children: [
              SizedBox(width: 8), // Spacing between the icon and text
              AppText(
                  text: AppStrings.Warning,
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              SizedBox(
                width: 4,
              ),
              Image.asset(
                AppImages.info,
                height: 25,
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    // Handle dismiss
                  },
                ),
              ),
            ],
          ),
          // Warning message
          AppText(
              text: AppStrings
                  .Warning_You_have_iolated_our_community_olicy_again,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.white)
          // Close button
        ],
      ),
    );
  }
}
