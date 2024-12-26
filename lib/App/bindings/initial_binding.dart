import 'package:civitante/App/modules/auth/controller/auth_controller.dart';
import 'package:civitante/App/modules/splash/controller/splash_controller.dart';
import 'package:civitante/App/utilse/widgets.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SplashController());
    Get.lazyPut(()=>AuthController());

  }
}
