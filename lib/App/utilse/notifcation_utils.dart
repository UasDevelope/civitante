import 'dart:convert';
import 'dart:developer' as log;
import 'dart:io';
import 'dart:math';

import 'package:civitante/App/utilse/pref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationUtil {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static bool _isInitialized = false;

  void allTasks(BuildContext context) async {
    await requestNotificationPermission();
    await firebaseInit(context);
    await onInteractMessage(context);
    await getToken().then((value) {
      String tokenString = PrefUtil.getString(PrefUtil.token);
      log.log("Token is $tokenString");
      if (tokenString != "" && tokenString != value) {
        PrefUtil.setString(PrefUtil.token, value);
        log.log("Value is $value");
        // PrefUtil.saveToken(value);
      }
    });
  }

  Future<void> firebaseInit(BuildContext context) async {
    if (!_isInitialized) {
      await initNotification(context);
      _isInitialized = true;
    }

    FirebaseMessaging.onMessage.listen((message) {
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      log.log("Notification Title: ${title ?? 'No Title'}");
      log.log("Notification Body: ${body ?? 'No Body'}");
      log.log("Data: ${message.data.toString()}");

      if (Platform.isAndroid || Platform.isIOS) {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    log.log("Preparing to show notification");

    // Check notification type
    String? notificationType = message.data["notificationType"];

    if (notificationType != "message") {
      log.log("Displaying simple notification");

      AndroidNotificationDetails androidSimpleNotificationDetails =
          const AndroidNotificationDetails(
        "general_notifications",
        "General Notifications",
        channelDescription: "Basic notification for non-message alerts",
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
        icon: '@drawable/notification_icon',
        sound: RawResourceAndroidNotificationSound("sound"),
      );

      const DarwinNotificationDetails darwinSimpleNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'sound.caf',
      );

      NotificationDetails simpleNotificationDetails = NotificationDetails(
        android: androidSimpleNotificationDetails,
        iOS: darwinSimpleNotificationDetails,
      );

      Future.delayed(Duration.zero, () {
        flutterLocalNotificationsPlugin.show(
          2, // Unique ID for non-message notifications
          message.notification?.title ?? "Notification",
          message.notification?.body ?? "You have a new update",
          simpleNotificationDetails,
          payload: jsonEncode(message.data),
        );
      });

      return;
    }

    // If notificationType is "message", show a rich notification
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      "Chat Messages",
      sound: RawResourceAndroidNotificationSound("sound"),
    );

    var sender = Person(
      name: message.notification!.title ?? "Unknown Sender",
      key: "chat_key",
      icon: const DrawableResourceAndroidIcon('@mipmap/ic_launcher'),
    );

    var messagingStyle = MessagingStyleInformation(
      sender,
      conversationTitle: "New Message",
      groupConversation: true,
      messages: [
        Message(
          message.notification?.body ?? "New Message",
          DateTime.now(),
          sender,
        ),
      ],
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id.toString(),
      androidNotificationChannel.name.toString(),
      channelDescription: "This is desc",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      icon: '@drawable/notification_icon',
      sound: RawResourceAndroidNotificationSound("sound"),
      styleInformation: messagingStyle,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'sound.caf',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        1,
        "New Message",
        message.notification!.body ?? "Tap to reply",
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    });
  }

  Future<void> onInteractMessage(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      handelMessage(context, message);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handelMessage(context, event);
    });
  }

  void handelMessage(BuildContext context, RemoteMessage message) {
    log.log("Handling message - Message Data: ${message.data}");
    if (message.notification != null) {
      log.log("Handling message - Title: ${message.notification!.title}");
      log.log("Handling message - Body: ${message.notification!.body}");
    } else {
      log.log("Handling message - No notification payload found");
    }
  }

  Future<String> getToken() async {
    try {
      String? token = await firebaseMessaging.getToken();
      log.log("Retrieved token: $token");
      return token ?? "123";
    } catch (error) {
      log.log("Error getting token: $error");
      return error.toString();
    }
  }

  Future<void> isTokenChange() async {
    firebaseMessaging.onTokenRefresh.listen((String? event) async {
      log.log("Token refreshed: $event");
    });
  }

  Future<void> initNotification(BuildContext context) async {
    log.log("Initializing notifications");

    var androidInitialization =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitialization = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          "message_category",
          actions: [
            DarwinNotificationAction.text(
              "REPLY_ACTION",
              "Reply",
              buttonTitle: "Send",
              placeholder: "Type your reply...",
              options: {DarwinNotificationActionOption.foreground},
            ),
            DarwinNotificationAction.plain("SEEN_ACTION", "Mark as Seen",
                options: {DarwinNotificationActionOption.foreground}),
            DarwinNotificationAction.plain("MUTE_ACTION", "Mute",
                options: {DarwinNotificationActionOption.foreground}),
          ],
        ),
      ],
    );

    var initializationSetting = InitializationSettings(
        android: androidInitialization, iOS: iosInitialization);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log.log(
            "Notification Response - Action ID: ${response.actionId}, Payload: ${response.payload}");
        switch (response.actionId) {
          case "REPLY_ACTION":
            if (response.input != null && response.input!.isNotEmpty) {
              log.log("Reply Received: ${response.input}");
            }
            break;
          case "SEEN_ACTION":
            log.log("Notification marked as seen");
            break;
          case "MUTE_ACTION":
            log.log("Notification muted");
            break;
          default:
            log.log("Unknown action triggered");
        }
      },
    );

    log.log("Notifications: Initialized once");
    log.log("Notifications: initialized");
  }

  static Future<void> requestNotificationPermission() async {
    Permission notificationPermission = Permission.notification;
    bool isPermanentlyDenied = await notificationPermission.isPermanentlyDenied;
    if (isPermanentlyDenied) {
      log.log("Notification permission permanently denied");
      await openAppSettings();
    } else {
      var requestNotification = await notificationPermission.request();
      if (requestNotification.isGranted) {
        log.log("Notification permission granted");
      } else {
        log.log(
            "Notification permission denied ${requestNotification.isDenied}");
      }
    }
  }
}
// class NotificationUtil {
//   static final AwesomeNotifications _awesomeNotifications =
//       AwesomeNotifications();
//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//   // Initialize all tasks
//   void allTasks(BuildContext context) async {
//     await requestNotificationPermission();
//     await initializeAwesomeNotifications(
//         context); // Pass context for action handling
//     await firebaseInit(context);
//     await onInteractMessage(context);
//     await getToken().then((value) {
//       String tokenString = PrefUtil.getString(PrefUtil.token);
//       print("Token is $tokenString");
//       if (tokenString != "" && tokenString != value) {
//         PrefUtil.setString(PrefUtil.token, value);
//         log.log("Value is $value");
//       }
//     });
//   }
//
//   // Initialize Awesome Notifications with action listeners
//   Future<void> initializeAwesomeNotifications(BuildContext context) async {
//     await _awesomeNotifications.initialize(
//       null, // Default icon (optional)
//       [
//         NotificationChannel(
//           channelKey: 'basic_channel',
//           channelName: 'Basic Notifications',
//           channelDescription: 'Notification channel for basic alerts',
//           importance: NotificationImportance.Max,
//           playSound: true,
//           soundSource: 'resource://raw/sound', // Optional custom sound
//           defaultColor: AppColors.appColor,
//           ledColor: Colors.white,
//           enableVibration: true,
//         ),
//       ],
//       debug: true, // Enable debug logs
//     );
//
//     // Set up action listeners
//     _awesomeNotifications.setListeners(
//       onActionReceivedMethod: NotificationUtil.onActionReceived,
//       onNotificationCreatedMethod: NotificationUtil.onNotificationCreated,
//       onNotificationDisplayedMethod: NotificationUtil.onNotificationDisplayed,
//       onDismissActionReceivedMethod: NotificationUtil.onDismissActionReceived,
//     );
//   }
//
//   // Handle action received (e.g., reply button clicked)
//   static Future<void> onActionReceived(ReceivedAction action) async {
//     log.log("User interacted with notification: ${action.buttonKeyPressed}");
//
//     if (action.buttonKeyPressed == 'REPLY') {
//       final inputText =
//           action.buttonKeyInput; // Get the text input from the user
//       log.log("User replied with: $inputText");
//       handleStaticMessage({
//         'reply': inputText,
//         ...action.payload ?? {},
//       });
//     } else {
//       log.log("Other action received: ${action.payload}");
//       handleStaticMessage(action.payload ?? {});
//     }
//   }
//
//   static Future<void> onNotificationCreated(
//       ReceivedNotification notification) async {
//     log.log("Notification created: ${notification.id}");
//   }
//
//   static Future<void> onNotificationDisplayed(
//       ReceivedNotification notification) async {
//     log.log("Notification displayed: ${notification.id}");
//   }
//
//   static Future<void> onDismissActionReceived(ReceivedAction action) async {
//     log.log("Notification dismissed: ${action.id}");
//   }
//
//   // Static handler for message
//   static void handleStaticMessage(Map<String, dynamic> data) {
//     log.log("Handling message statically: $data");
//     if (data.containsKey('reply')) {
//       log.log("Reply received: ${data['reply']}");
//       // Add logic here to send the reply (e.g., to Firebase or an API)
//     }
//   }
//
//   // Initialize Firebase Messaging and listen for messages
//   Future<void> firebaseInit(BuildContext context) async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       print("Foreground message received: ${message.messageId}");
//       print(
//           "Notification: ${message.notification?.title} - ${message.notification?.body}");
//       print("Data: ${message.data}");
//
//       // Only show custom notification if app is in foreground and we need custom UI
//       if (Platform.isIOS) {
//         final appState = WidgetsBinding.instance.lifecycleState;
//         if (appState == AppLifecycleState.resumed) {
//           // App is in foreground: show custom notification with reply button
//           await showNotification(message);
//         } else {
//           // App is in background: let Firebase/APNs handle it
//           log.log("iOS: Letting system handle notification in background");
//           return;
//         }
//       } else if (Platform.isAndroid) {
//         // Android: always use awesome_notifications for consistency
//         await showNotification(message);
//       }
//     });
//
//     // Handle background messages (optional)
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
//
// // Background handler (outside class)
//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     if (message.notification != null) {
//       await NotificationUtil().showNotification(message);
//     }
//     // Don’t create a notification here unless required
//   }
//
//   // Show notification with a reply button
//   Future<void> showNotification(RemoteMessage message) async {
//     try {
//       await _awesomeNotifications.createNotification(
//         content: NotificationContent(
//           id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
//           channelKey: 'basic_channel',
//           title: message.notification?.title ?? 'New Notification',
//           body: message.notification?.body ?? 'You have a new message!',
//           notificationLayout:
//               NotificationLayout.Messaging, // WhatsApp-like layout
//           payload: message.data.cast<String, String>(), // Pass FCM data
//         ),
//         actionButtons: [
//           NotificationActionButton(
//             key: 'REPLY',
//             autoDismissible: true,
//
//             label: 'Reply',
//
//             requireInputText: true, // Enables text input field
//             // buttonType: ActionButtonType.InputField,
//             color: AppColors.red_color,
//             actionType: ActionType.SilentBackgroundAction,
//           ),
//           NotificationActionButton(
//             key: 'Mark As seen',
//             label: "Mark as seen",
//             autoDismissible: true,
//             actionType: ActionType.SilentBackgroundAction,
//           ),
//         ],
//       );
//     } catch (e) {
//       log.log("Error showing notification: $e");
//     }
//   }
//
//   // Handle message interactions (e.g., app opened from notification)
//   Future<void> onInteractMessage(BuildContext context) async {
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       handleMessage(context, initialMessage);
//     }
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
//       handleMessage(context, event);
//     });
//   }
//
//   // Handle the message logic
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     log.log("Handling message: ${message.data}");
//     // Add navigation or custom logic here if needed
//   }
//
//   // Get FCM token
//   Future<String> getToken() async {
//     try {
//       if (Platform.isIOS) {
//         String? apnsToken = await firebaseMessaging.getAPNSToken();
//         if (apnsToken == null) {
//           log.log("APNs token not available yet, retrying...");
//           await Future.delayed(const Duration(seconds: 1));
//           apnsToken = await firebaseMessaging.getAPNSToken();
//         }
//         log.log("APNs Token: $apnsToken");
//       }
//
//       String? token = await firebaseMessaging.getToken();
//       log.log("FCM Token is $token");
//       return token ?? "123";
//     } catch (error) {
//       print("Error fetching token: $error");
//       return error.toString();
//     }
//   }
//
//   // Monitor token refresh
//   Future<void> isTokenChange() async {
//     firebaseMessaging.onTokenRefresh.listen((String? event) async {
//       print("Refreshed token: $event");
//       if (event != null) {
//         PrefUtil.setString(PrefUtil.token, event);
//       }
//     });
//   }
//
//   // Request notification permission
//   Future<void> requestNotificationPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('✅ User granted permission');
//     } else {
//       print('❌ User denied permission');
//     }
//   }
//
//   // Trigger a local notification for testing
//   // Future<void> triggerLocalNotification() async {
//   //   await AwesomeNotifications().createNotification(
//   //     content: NotificationContent(
//   //       actionType: ActionType.SilentBackgroundAction,
//   //       id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//   //       channelKey: 'basic_channel',
//   //       title: 'Test Local Notification',
//   //       showWhen: true,
//   //       summary: "Hello",
//   //       body: 'This is a local notification test!',
//   //       notificationLayout: NotificationLayout.Messaging,
//   //     ),
//   //     actionButtons: [
//   //       NotificationActionButton(
//   //         autoDismissible: false,
//   //         actionType: ActionType.KeepOnTop,
//   //         key: 'REPLY',
//   //         label: 'Reply',
//   //         requireInputText: true, // Enables text input field
//   //         // buttonType: ActionButtonType.InputField,
//   //         color: AppColors.red_color,
//   //       ),
//   //     ],
//   //   );
//   // }
// }
