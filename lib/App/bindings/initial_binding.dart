import 'package:civitante/App/modules/auth/controller/auth_controller.dart';
import 'package:civitante/App/modules/bottom/controller/bottom_nave_controller.dart';
import 'package:civitante/App/modules/communities/controller/controllerCommunity.dart';
import 'package:civitante/App/modules/contactadmin/controller/contact_admin.dart';
import 'package:civitante/App/modules/forget/controller/forget_controller.dart';
import 'package:civitante/App/modules/home/controller/home_controller.dart';
import 'package:civitante/App/modules/mycommunites/controller/my_community.dart';
import 'package:civitante/App/modules/setting/controller/setting.dart';
import 'package:civitante/App/modules/splash/controller/splash_controller.dart';
import 'package:civitante/App/modules/wallet/controller/wallet_controller.dart';
import 'package:civitante/App/utilse/widgets.dart';

import '../modules/AddCommunity/controller/add_community.dart';
import '../modules/Addpost/controller/post.dart';
import '../modules/drawer/controller/drawer.dart';
import '../modules/editMyCommunity/controller/editCommunityController.dart';
import '../modules/fqas/controller/fqaa.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => ForgetPassworController());
    Get.lazyPut(() => BottomNaveController());
    Get.lazyPut(() => CustomDrawerController());
    Get.lazyPut(() => MyCommunityController());
    Get.lazyPut(() => CommunityController());
    Get.lazyPut(() => ContactAdminController());
    Get.lazyPut(() => SettingController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PostController());
    Get.lazyPut(() => WalletController());
    Get.lazyPut(() => SettingController());
    Get.lazyPut(() => AddCommunityController());
    Get.lazyPut(() => EditCommunityController());
    Get.lazyPut<FAQController>(() => FAQController());
  }
}
