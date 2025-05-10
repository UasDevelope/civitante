import 'dart:io';

import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'App/utilse/notifcation_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase in the background isolate
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  if (message.notification != null) {
    print("Background Notification Title: ${message.notification!.title}");
    print("Background Notification Body: ${message.notification!.body}");
  } else {
    print("No notification payload in background message");
  }
  print("Background Data: ${message.data}");

  // Show notification using NotificationUtil
  await NotificationUtil().showNotification(message);
}

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Stripe.publishableKey = 'pk_test_I71hW1HMRNeKcsF2IRuQk3ga00ZtdU01e5';
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  // await Stripe.instance.applySettings();
  HttpOverrides.global = MyHttpOverrides();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  PrefUtil.init();

//
  runApp(CivitanteApp());
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
