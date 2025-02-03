import 'package:civitante/App/modules/auth/view/login.dart';
import 'package:civitante/App/modules/auth/view/pro_account.dart';
import 'package:civitante/App/modules/auth/view/signup.dart';
import 'package:civitante/App/modules/bottom/view/bottom_nav.dart';
import 'package:civitante/App/modules/communities/view/community.dart';
import 'package:civitante/App/modules/communityDetails/view/communityDetails.dart';
import 'package:civitante/App/modules/editMyCommunity/view/edityMyCommunity.dart';
import 'package:civitante/App/modules/forget/view/new_password.dart';
import 'package:civitante/App/modules/forget/view/send_otp.dart';
import 'package:civitante/App/modules/forget/view/verify_otp.dart';
import 'package:civitante/App/modules/mycommunites/view/my_communities.dart';
import 'package:civitante/App/modules/setting/view/setting.dart';
import 'package:civitante/App/modules/splash/view/splash.dart';
import 'package:civitante/App/utilse/widgets.dart';

import '../modules/AddCommunity/view/addCommunity.dart';
import '../modules/AllCommunities/view/Allcommunities.dart';
import '../modules/PostsDetails/view/posts_details_screen.dart';
import '../modules/fqas/view/fqa.dart';
import '../modules/started/started.dart';
import '../testing.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: AppRoutes.splash,
        page: () => SplashScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.started,
        page: () => StartedScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.login,
        page: () => LoginScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.signup,
        page: () => SignupScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.proAccound,
        page: () => ProAccountScren(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.forgetPassword,
        page: () => SendOtp(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.verifyOtp,
        page: () => VerifyOtp(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.newPassword,
        page: () => NewPassword(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.bottomNav,
        page: () => BottomNavScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.myCommunity,
        page: () => MyCommunitiesScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.communities,
        page: () => CommunityScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.contactAdmin,
        page: () => AdminContactScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.setting,
        page: () => SettingScreen(),
        binding: InitialBinding()),
    GetPage(
      name: AppRoutes.fqa,
      page: () => FAQPage(),
      binding: InitialBinding(),
    ),
    GetPage(
        name: AppRoutes.post,
        page: () => PostScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.postDetail,
        page: () => PostsDetailsScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.addCommunity,
        page: () => AddCommunityScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.communityDetail,
        page: () => MyCommunityDetail(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.editMycommunity,
        page: () => EditCommunityScreen(),
        binding: InitialBinding()),
    GetPage(
        name: AppRoutes.Allcommunities,
        page: () => AllCommunitiesScreen(),
        binding: InitialBinding()),
  ];
}
