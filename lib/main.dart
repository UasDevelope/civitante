import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_I71hW1HMRNeKcsF2IRuQk3ga00ZtdU01e5';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  PrefUtil.init();
  await Firebase.initializeApp();
  runApp(CivitanteApp());
}

class CivitanteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialRoute:
          AppRoutes.splash, // Ensure AppRoutes.splash is defined correctly.
      initialBinding:
          InitialBinding(), // Ensure InitialBinding() is correctly set up.
      defaultTransition:
          Transition.fadeIn, // Optional: for smoother page transitions.
    );
  }
}
