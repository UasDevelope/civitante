import 'package:civitante/App/modules/auth/view/face_id_screen.dart';
import 'package:civitante/App/modules/auth/view/otp_screen.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_I71hW1HMRNeKcsF2IRuQk3ga00ZtdU01e5';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
