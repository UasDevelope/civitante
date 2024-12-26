import 'package:civitante/App/modules/auth/view/login.dart';
import 'package:civitante/App/modules/splash/view/splash.dart';
import 'package:civitante/App/utilse/widgets.dart';
import '../modules/started/started.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),

    GetPage(name: AppRoutes.started, page: () => StartedScreen()),

    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
  ];
}
