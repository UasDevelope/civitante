import 'package:civitante/App/modules/home/widgets/homeAppbar.dart';
import 'package:civitante/App/shared/app_text.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/notification_model.dart';
import '../controller/notification.dart';

// notifications_screen.dart
class NotificationsScreen extends StatelessWidget {
  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HomeAppbar(title: "Notifications"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final groupedNotifications = controller.groupedNotifications;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: groupedNotifications.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(entry.key),
                ...entry.value.map(_buildNotificationItem).toList(),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AppText(
        text: title,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.appColor,
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
          title: AppText(
            text: item.title,
            fontWeight: item.isBold ? FontWeight.bold : FontWeight.normal,
            color: item.isBold || item.isHighlighted
                ? Colors.black
                : AppColors.Slate_gray,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: item.body,
                color: AppColors.Slate_gray,
                fontSize: 12,
              ),
              if (item.category == "community_invite")
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.respondToInvite(
                                item.extraData!["inviteId"],
                                action: "accept");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.respondToInvite(
                                item.extraData!["inviteId"],
                                action: "reject");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            "Reject",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
