import 'package:civitante/App/modules/AddCommunity/controller/add_community.dart';
import 'package:civitante/App/modules/PostsDetails/controller/posts_details_controller.dart';
import 'package:civitante/App/modules/auth/controller/auth_controller.dart';
import 'package:civitante/App/modules/bottom/controller/bottom_nave_controller.dart';
import 'package:civitante/App/modules/forget/controller/forget_controller.dart';
import 'package:civitante/App/modules/home/controller/home_controller.dart';
import 'package:civitante/App/modules/profile/controller/profile_controller.dart';
import 'package:civitante/App/modules/setting/controller/setting.dart';
import 'package:civitante/App/modules/wallet/controller/wallet_controller.dart';
import 'package:civitante/App/utilse/location_controller.dart';
import 'package:civitante/App/utilse/widgets.dart';
import '../modules/Addpost/controller/post.dart';
import '../modules/communityDetails/controller/communityDetailsController.dart';
import '../modules/drawer/controller/drawer.dart';
import '../modules/editMyCommunity/controller/editCommunityController.dart';
import '../modules/mycommunites/controller/my_community.dart';

class LocateController {
  static SplashController get splashController => Get.find<SplashController>();
  static AuthController get authController => Get.find<AuthController>();
  static ForgetPassworController get forgetPassworController =>
      Get.find<ForgetPassworController>();
  static BottomNaveController get bottomNaveController =>
      Get.find<BottomNaveController>();
  static CustomDrawerController get drawerController =>
      Get.find<CustomDrawerController>();
  static HomeController get homeController => Get.find<HomeController>();
  static PostController get postController => Get.find<PostController>();
  static PostsDetailsController get postDetailController =>
      Get.find<PostsDetailsController>();
  static WalletController get walletController => Get.find<WalletController>();
  static SettingController get settingController =>
      Get.find<SettingController>();
  static MyCommunityController get myCommunityController =>
      Get.find<MyCommunityController>();
  static CommunityDetailController get communityDetailController =>
      Get.find<CommunityDetailController>();
  static EditCommunityController get editCommunityDetailController =>
      Get.find<EditCommunityController>();
  static AddCommunityController get addCommunityController =>
      Get.find<AddCommunityController>();
  static LocationController get locationController =>
      Get.find<LocationController>();
  static EditProfileController get profileController =>
      Get.find<EditProfileController>();
}
