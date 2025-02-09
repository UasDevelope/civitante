import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:civitante/App/utilse/widgets.dart';

import '../../../shared/strings.dart';
import '../../drawer/view/drawer.dart';
import '../widgets/history_items.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocateController.walletController;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(
        title: AppStrings.Wallet,
        rightIcon: AppImages.notification,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Points Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(
                        236, 236, 236, 0.7), // Slightly stronger gradient
                    Color.fromRGBO(
                        236, 236, 236, 0.3), // Subtle difference for effect
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(12), // Smooth rounded corners
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  AppText(
                    text: AppStrings.Current_Points,
                    color: AppColors.appColor, // Use appColor for consistency
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0, // Slightly larger for better visibility
                  ),
                  const SizedBox(height: 8.0),

                  // Points and Percentage Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Points
                      AppText(
                        text: "8,003,452.4",
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: AppColors.appColor, // AppColor for consistency
                      ),
                      const SizedBox(width: 15),

                      // Up Arrow Icon
                      Image.asset(
                        AppImages.arrowup,
                        height: 20,
                        width: 20,
                        color: AppColors
                            .moreblue, // GreenAccent for positive change

                        fit: BoxFit.contain,
                      ),
                      // Percentage Change
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: AppText(
                          text: "10.2%",
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors
                              .moreblue, // GreenAccent for positive change
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Spacing below the container

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  height: 50,
                  textColor: AppColors.white,
                  radius: 35,
                  useGradient: false,
                  width: Get.width / 2.4,
                  color: AppColors.appColor,
                  text: AppStrings.Buy_Points_with_USD,
                  onPressed: () {},
                ),
                AppButton(
                  height: 50,
                  borderColor: AppColors.appColor,
                  borderWidht: 1,
                  useGradient: false,
                  textColor: AppColors.appColor,
                  radius: 35,
                  width: Get.width / 2.4,
                  color: AppColors.white,
                  text: AppStrings.Withdraw,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Scrollable History Sections
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // History Section
                    Obx(() => HistorySection(
                          title: AppStrings.History,
                          items: controller.showMoreHistory.value
                              ? controller.historyData
                              : controller.historyData.take(2).toList(),
                          onSeeAll: controller.toggleHistory,
                        )),

                    const SizedBox(height: 16.0),

                    // Posts History Section
                    Obx(() => HistorySection(
                          title: AppStrings.Posts_History,
                          items: controller.showMorePostsHistory.value
                              ? controller.postsHistoryData
                              : controller.postsHistoryData.take(2).toList(),
                          onSeeAll: controller.togglePostsHistory,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // drawer: CustomDrawer(),
    );
  }
}
