import 'package:civitante/App/routes/routes.dart';
import 'package:civitante/App/shared/color.dart';
import 'package:civitante/App/shared/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../../controller/controller_locate.dart';
import '../widgets/bottomNav.dart';

class BottomNavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = LocateController.bottomNaveController;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => LoadingOverlay(
          isLoading: controller.showloading.value,
          child: controller.pages[controller.currentIndex.value])),
      // floatingActionButton: SizedBox(
      //   width: Get.width * 0.2, // Adjust the button width
      //   height: Get.height * 0.1, // Adjust the button height
      //   child: FloatingActionButton(
      //     shape: CircleBorder(),
      //     backgroundColor: Colors.black,
      //     onPressed: () {
      //       Get.toNamed(AppRoutes.post);
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.all(
      //           10.0), // Adjust the padding to decrease image size
      //       child: Image.asset(
      //         AppImages.add,
      //         height: 40,
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() => BottomAppBar(
            color: Colors.black,
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: Container(
              height: 40, // Adjust height to match your design
              child: Row(
                // spacing:40,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNavItem(
                    icon: AppImages.home,
                    isActive: controller.currentIndex.value == 0,
                    onTap: () => controller.changeIndex(0),
                  ),
                  buildNavItem(
                    icon: AppImages.search,
                    isActive: controller.currentIndex.value == 1,
                    onTap: () => controller.changeIndex(1),
                  ),
                  buildNavItem(
                    icon: AppImages.add,
                    isActive: controller.currentIndex.value == 2,
                    onTap: () => controller.changeIndex(2),
                  ),
                  buildNavItem(
                    icon: AppImages.wallet,
                    isActive: controller.currentIndex.value == 3,
                    onTap: () => controller.changeIndex(3),
                  ),
                  buildNavItem(
                    icon: AppImages.profile,
                    isActive: controller.currentIndex.value == 4,
                    onTap: () => controller.changeIndex(4),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
