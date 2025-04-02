import 'dart:developer';

import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:civitante/App/utilse/widgets.dart';

import '../../../Models/notification_model.dart';
import '../../../service/http_service.dart';

// notification_controller.dart
class NotificationsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await HttpService.get("/getNotifications");
      log("Response for the get notifications are $response");

      if (response['success']) {
        notifications.value = (response['notifications'] as List)
            .map((json) => NotificationItem.fromJson(json))
            .toList();
      }
    } catch (e) {
      log("Error getting notification $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinCommunity(String communityId) async {
    try {
      CustomLoadingDialog.showCustomLoadingDialog("");
      final response =
          await HttpService.post("/joinCommunity/$communityId", {});

      fetchNotifications();
      CustomLoadingDialog.closeLoadingDialog();
      log("Join community response is $response");
    } catch (e) {
      log("Error is $e");
      CustomLoadingDialog.closeLoadingDialog();
    } finally {}
  }

  Future<void> respondToInvite(String inviteId,
      {String action = "accept"}) async {
    try {
      CustomLoadingDialog.showCustomLoadingDialog("");
      final response = await HttpService.post(
          "/respondToInvite/$inviteId", {"action": action});
      fetchNotifications();
      CustomLoadingDialog.closeLoadingDialog();
      log("Join community response is $response");
    } catch (e) {
      log("Error is $e");
      CustomLoadingDialog.closeLoadingDialog();
    } finally {}
  }

  Map<String, List<NotificationItem>> get groupedNotifications {
    final Map<String, List<NotificationItem>> grouped = {};

    for (var notification in notifications) {
      final timeDisplay = notification.getTimeDisplay();
      if (!grouped.containsKey(timeDisplay)) {
        grouped[timeDisplay] = [];
      }
      grouped[timeDisplay]!.add(notification);
    }

    return grouped;
  }

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }
}
