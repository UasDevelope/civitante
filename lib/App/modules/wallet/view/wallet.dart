import 'package:civitante/App/utilse/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:intl/intl.dart';
import '../../../service/payment_service.dart';
import '../../../shared/strings.dart';
import '../controller/wallet_controller.dart';
import 'BuyPointsScreen.dart';

class AppColor {
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF43A047);
  static const Color blue = Color(0xFF1976D2);
  static const Color black = Color(0xFF000000);
// ... other colors
}

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});
  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(
        title: AppStrings.Wallet,
        rightIcon: AppImages.notification,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return RefreshIndicator(
          onRefresh: () async => await controller.loadPoints(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Points Balance Card
                  _buildPointsCard(),
                  const SizedBox(height: 16),

                  // Action Buttons
                  _buildActionButtons(context),
                  const SizedBox(height: 24),

                  // Transaction History
                  _buildHistorySection(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(236, 236, 236, 0.7),
            Color.fromRGBO(236, 236, 236, 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: AppStrings.Current_Points,
            color: AppColors.appColor,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Obx(() => AppText(
                    text: NumberFormat.decimalPattern().format(
                      controller.pointsData.value?.availablePoints ?? 0,
                    ),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.appColor,
                  )),
              SizedBox(width: 15),
              // Add percentage change UI if needed
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton(
          height: 50,
          textColor: AppColors.white,
          radius: 35,
          width: Get.width / 2.4,
          color: AppColors.appColor,
          text: AppStrings.Buy_Points_with_USD,
          onPressed: () => _handleBuyPoints(context),
        ),
        AppButton(
          height: 50,
          borderColor: AppColors.appColor,
          borderWidht: 1,
          textColor: AppColors.appColor,
          radius: 35,
          width: Get.width / 2.4,
          color: AppColors.white,
          text: AppStrings.Withdraw,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Obx(() => HistorySection(
          title: 'Transaction History',
          items: controller.pointsData.value?.transactionHistory
                  .map((transaction) => HistoryItem(
                        type: transaction.type,
                        title: transaction.type,
                        subtitle: transaction.reason ?? 'No description',
                        points: '${transaction.points} PTS',
                        date: DateFormat('MMM dd, yyyy – HH:mm')
                            .format(transaction.createdAt),
                      ))
                  .toList() ??
              [],
          onSeeAll: controller.toggleHistory,
        ));
  }

  void _handleBuyPoints(BuildContext context) async {
    if (controller.pointsData.value?.paymentId == true) {
      Get.to(() => BuyPointsScreen());
    } else {
      final success = await PaymentService().makePayment(context);
      if (success) {
        controller.pointsData.value?.paymentId = true;
        Get.to(() => BuyPointsScreen());
      }
    }
  }
}

// History Section Widget
class HistorySection extends StatelessWidget {
  final String title;
  final List<HistoryItem> items;
  final VoidCallback onSeeAll;

  const HistorySection({
    required this.title,
    required this.items,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        Column(
          children: items.map((item) => item).toList(),
        ),
      ],
    );
  }
}

// History Item Widget

class HistoryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String points;
  final String date;
  final String type;

  const HistoryItem({
    required this.title,
    required this.subtitle,
    required this.points,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color pointsColor = AppColor.black;
    Color dateColor = AppColors.greyShade;

    switch (type.toLowerCase()) {
      case 'spend':
        pointsColor = AppColor.red;
        dateColor = AppColor.black;
        break;
      case 'purchase':
        pointsColor = AppColors.green;
        dateColor = AppColors.blue;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: AppText(
          text: title.isNotEmpty
              ? title[0].toUpperCase() + title.substring(1)
              : '',
          fontWeight: FontWeight.w500,
        ),
        subtitle: AppText(
          text: subtitle,
          fontSize: 14,
          color: AppColors.Slate_gray,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(
              text: points,
              fontWeight: FontWeight.w600,
              color: pointsColor,
            ),
            SizedBox(height: 4),
            AppText(
              text: date,
              fontSize: 12,
              color: dateColor,
            ),
          ],
        ),
      ),
    );
  }
}
