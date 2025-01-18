import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notification.dart';
import '../model/notification_item.dart';
class NotificationsScreen extends StatelessWidget {
  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.white,
      appBar:HomeAppbar(title: "Notifications"),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionTitle('Today'),
            ...controller.todayNotifications.map(_buildNotificationItem).toList(),
            const SizedBox(height: 16),
            _buildSectionTitle('Yesterday'),
            ...controller.yesterdayNotifications.map(_buildNotificationItem).toList(),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AppText(
        text:
        title,
        fontWeight:FontWeight.w500,
        fontSize:14,
        color:AppColors.appColor
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem item) {
    return Column(
      children: [
        ListTile(
          leading: item.icon != null
              ? Icon(
            item.icon,
            color: item.isHighlighted ? Colors.amber : Colors.blue,
          )
              : null,
          title: AppText(text:
            item.title,
            fontWeight: item.isBold ? FontWeight.bold : FontWeight.normal,
            color: item.isBold || item.isHighlighted ? Colors.black :AppColors.Slate_gray,
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

