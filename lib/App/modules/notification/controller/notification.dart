import 'dart:developer';

import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

import '../../../service/http_service.dart';
import '../model/notification_item.dart';

class NotificationsController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
    } catch (e) {
      log("Error getting notification $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinCommunity(String communityId) async {
    try {
      final response =
          await HttpService.post("/joinCommunity/$communityId", {});
      log("Join community response is $response");
    } catch (e) {
      log("Error is $e");
    } finally {}
  }

  // Sample data
  final todayNotifications = [
    NotificationItem(
      title: 'Lorem ipsum dolor sit amet',
      icon: Icons.person,
      isBold: true,
    ),
    NotificationItem(
      title: 'Lorem ipsum dolor sit amet consectetur.',
      icon: Icons.check_circle,
    ),
    NotificationItem(
      title:
          'Lorem ipsum dolor sit amet consectetur. Nunc duis egestas cras feugiat.',
      icon: Icons.star,
      isHighlighted: true,
    ),
    NotificationItem(title: 'Lorem ipsum dolor sit amet'),
  ].obs;

  final yesterdayNotifications = [
    NotificationItem(title: 'Lorem ipsum dolor sit amet'),
    NotificationItem(title: 'Lorem ipsum dolor sit amet consectetur.'),
    NotificationItem(
      title:
          'Lorem ipsum dolor sit amet consectetur. Nunc duis egestas cras feugiat.',
    ),
    NotificationItem(title: 'Lorem ipsum dolor sit amet'),
  ].obs;
}
