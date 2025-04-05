import 'package:civitante/App/modules/wallet/view/transaction_history.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../kpi/controller/kpis_controller.dart';
import '../../kpi/view/kpis_screen.dart';
import '../../shimmer/kpis_shimmer.dart';
import '../controller/wallet_controller.dart';
import 'BuyPointsScreen.dart';

class AppColor {
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF43A047);
  static const Color blue = Color(0xFF1976D2);
  static const Color black = Color(0xFF000000);
}

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final WalletController controller = Get.put(WalletController());
  final KPISController kpisController = Get.find<KPISController>();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    kpisController.fetchUserStats();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: AppText(
          text: "My Wallet",
          fontWeight: FontWeight.w500,
          fontSize: isTablet ? 24 : 20,
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(TransactionHistoryScreen()),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 18),
              child: Image.asset(
                AppImages.history,
                height: isTablet ? 40 : 30,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(fontSize: isTablet ? 20 : 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => await controller.loadPoints(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 24 : 16,
                horizontal: isTablet ? 32 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => controller.isLoading.value
                      ? KpisShimmer(itemCount: 2)
                      : Column(
                          children: ["Posts", "Followers"]
                              .map((metric) => buildMetricSection(
                                  metric, kpisController, true))
                              .toList(),
                        )),
                  SizedBox(height: isTablet ? 32 : 23),
                  _buildPointsCard(isTablet),
                  SizedBox(height: isTablet ? 32 : 23),
                  _buildActionButtons(context, isTablet),
                  SizedBox(height: isTablet ? 32 : 24),
                  // _buildHistorySection(isTablet),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPointsCard(bool isTablet) {
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
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 20 : 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: AppStrings.Current_Points,
            color: AppColors.appColor,
            fontWeight: FontWeight.w400,
            fontSize: isTablet ? 20 : 16,
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Row(
            children: [
              Obx(() => AppText(
                    text: NumberFormat.decimalPattern().format(
                      controller.pointsData.value?.availablePoints ?? 0,
                    ),
                    fontSize: isTablet ? 32 : 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.appColor,
                  )),
              SizedBox(width: isTablet ? 20 : 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppButton(
          height: isTablet ? 60 : 50,
          textColor: AppColors.white,
          radius: 35,
          width: isTablet ? Get.width * 0.4 : Get.width * 0.45,
          color: AppColors.appColor,
          text: AppStrings.Buy_Points_with_USD,
          onPressed: () => _handleBuyPoints(context),
        ),
        AppButton(
          height: isTablet ? 60 : 50,
          borderColor: AppColors.appColor,
          borderWidht: 1,
          textColor: AppColors.appColor,
          radius: 35,
          width: isTablet ? Get.width * 0.4 : Get.width * 0.45,
          color: AppColors.white,
          text: AppStrings.Withdraw,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHistorySection(bool isTablet) {
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
          isTablet: isTablet,
        ));
  }

  void _handleBuyPoints(BuildContext context) async {
    Get.to(() => BuyPointsScreen());
  }
}

class HistorySection extends StatelessWidget {
  final String title;
  final List<HistoryItem> items;
  final VoidCallback onSeeAll;
  final bool isTablet;

  const HistorySection({
    required this.title,
    required this.items,
    required this.onSeeAll,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: title,
                fontSize: isTablet ? 22 : 18,
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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
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
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 : 16,
          vertical: isTablet ? 12 : 8,
        ),
        title: AppText(
          text: title.isNotEmpty
              ? title[0].toUpperCase() + title.substring(1)
              : '',
          fontWeight: FontWeight.w500,
          fontSize: isTablet ? 18 : 16,
        ),
        subtitle: AppText(
          text: subtitle,
          fontSize: isTablet ? 16 : 14,
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
              fontSize: isTablet ? 18 : 16,
            ),
            SizedBox(height: isTablet ? 6 : 4),
            AppText(
              text: date,
              fontSize: isTablet ? 14 : 12,
              color: dateColor,
            ),
          ],
        ),
      ),
    );
  }
}
