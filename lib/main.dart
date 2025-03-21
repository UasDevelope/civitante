import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'App/utilse/notifcation_utils.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Stripe.publishableKey = 'pk_test_I71hW1HMRNeKcsF2IRuQk3ga00ZtdU01e5';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  PrefUtil.init();

//
  runApp(CivitanteApp());
}

@pragma('vm:entry-point')
// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
  // Use this method to automatically convert the push data, in case you gonna use our data standard
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

class CivitanteApp extends StatefulWidget {
  @override
  State<CivitanteApp> createState() => _CivitanteAppState();
}

class _CivitanteAppState extends State<CivitanteApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NotificationUtil().allTasks(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Civitante',
      getPages: AppPages.pages,
      initialRoute:
          AppRoutes.splash, // Ensure AppRoutes.splash is defined correctly.
      initialBinding:
          InitialBinding(), // Ensure InitialBinding() is correctly set up.

      // home: OtpScreen(),

      defaultTransition:
          Transition.fadeIn, // Optional: for smoother page transitions.
    );
  }
}
