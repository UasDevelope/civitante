import 'dart:developer' as log;
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationUtil {
  static final AwesomeNotifications _awesomeNotifications =
      AwesomeNotifications();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Initialize all tasks
  void allTasks(BuildContext context) async {
    await requestNotificationPermission();
    await initializeAwesomeNotifications(
        context); // Pass context for action handling
    await firebaseInit(context);
    await onInteractMessage(context);
    await getToken().then((value) {
      String tokenString = PrefUtil.getString(PrefUtil.token);
      print("Token is $tokenString");
      if (tokenString != "" && tokenString != value) {
        PrefUtil.setString(PrefUtil.token, value);
        log.log("Value is $value");
      }
    });
  }

  // Initialize Awesome Notifications with action listeners
  Future<void> initializeAwesomeNotifications(BuildContext context) async {
    await _awesomeNotifications.initialize(
      null, // Default icon (optional)
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic alerts',
          importance: NotificationImportance.Max,
          playSound: true,
          soundSource: 'resource://raw/sound', // Optional custom sound
          defaultColor: AppColors.appColor,
          ledColor: Colors.white,
          enableVibration: true,
        ),
      ],
      debug: true, // Enable debug logs
    );

    // Set up action listeners
    _awesomeNotifications.setListeners(
      onActionReceivedMethod: NotificationUtil.onActionReceived,
      onNotificationCreatedMethod: NotificationUtil.onNotificationCreated,
      onNotificationDisplayedMethod: NotificationUtil.onNotificationDisplayed,
      onDismissActionReceivedMethod: NotificationUtil.onDismissActionReceived,
    );
  }

  // Handle action received (e.g., reply button clicked)
  static Future<void> onActionReceived(ReceivedAction action) async {
    log.log("User interacted with notification: ${action.buttonKeyPressed}");

    if (action.buttonKeyPressed == 'REPLY') {
      final inputText =
          action.buttonKeyInput; // Get the text input from the user
      log.log("User replied with: $inputText");
      handleStaticMessage({
        'reply': inputText,
        ...action.payload ?? {},
      });
    } else {
      log.log("Other action received: ${action.payload}");
      handleStaticMessage(action.payload ?? {});
    }
  }

  static Future<void> onNotificationCreated(
      ReceivedNotification notification) async {
    log.log("Notification created: ${notification.id}");
  }

  static Future<void> onNotificationDisplayed(
      ReceivedNotification notification) async {
    log.log("Notification displayed: ${notification.id}");
  }

  static Future<void> onDismissActionReceived(ReceivedAction action) async {
    log.log("Notification dismissed: ${action.id}");
  }

  // Static handler for message
  static void handleStaticMessage(Map<String, dynamic> data) {
    log.log("Handling message statically: $data");
    if (data.containsKey('reply')) {
      log.log("Reply received: ${data['reply']}");
      // Add logic here to send the reply (e.g., to Firebase or an API)
    }
  }

  // Initialize Firebase Messaging and listen for messages
  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Notification Title: ${message.notification?.title ?? 'No Title'}");
      print("Notification Body: ${message.notification?.body ?? 'No Body'}");
      print("Data: ${message.data}");

      if (Platform.isAndroid || Platform.isIOS) {
        await showNotification(message);
      }
    });
  }

  // Show notification with a reply button
  Future<void> showNotification(RemoteMessage message) async {
    try {
      await _awesomeNotifications.createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
          channelKey: 'basic_channel',
          title: message.notification?.title ?? 'New Notification',
          body: message.notification?.body ?? 'You have a new message!',
          summary: 'Sustainability App',
          notificationLayout:
              NotificationLayout.Messaging, // WhatsApp-like layout
          payload: message.data.cast<String, String>(), // Pass FCM data
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'REPLY',
            label: 'Reply',
            requireInputText: true, // Enables text input field
            // buttonType: ActionButtonType.InputField,
            color: AppColors.appColor,
          ),
        ],
      );
    } catch (e) {
      log.log("Error showing notification: $e");
    }
  }

  // Handle message interactions (e.g., app opened from notification)
  Future<void> onInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      handleMessage(context, event);
    });
  }

  // Handle the message logic
  void handleMessage(BuildContext context, RemoteMessage message) {
    log.log("Handling message: ${message.data}");
    // Add navigation or custom logic here if needed
  }

  // Get FCM token
  Future<String> getToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          log.log("APNs token not available yet, retrying...");
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await firebaseMessaging.getAPNSToken();
        }
        log.log("APNs Token: $apnsToken");
      }

      String? token = await firebaseMessaging.getToken();
      log.log("FCM Token is $token");
      return token ?? "123";
    } catch (error) {
      print("Error fetching token: $error");
      return error.toString();
    }
  }

  // Monitor token refresh
  Future<void> isTokenChange() async {
    firebaseMessaging.onTokenRefresh.listen((String? event) async {
      print("Refreshed token: $event");
      if (event != null) {
        PrefUtil.setString(PrefUtil.token, event);
      }
    });
  }

  // Request notification permission
  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
    } else {
      print('❌ User denied permission');
    }
  }

  // Trigger a local notification for testing
  Future<void> triggerLocalNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        title: 'Test Local Notification',
        body: 'This is a local notification test!',
        notificationLayout: NotificationLayout.Messaging,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'REPLY',
          label: 'Reply',
          requireInputText: true,
          actionType: ActionType.Default,
          color: AppColors.appColor,
        ),
      ],
    );
  }
}
