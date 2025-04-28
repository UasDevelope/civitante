import 'package:civitante/App/utilse/widgets.dart';

import '../controller/profile_controller.dart';

class SwitchLane extends StatelessWidget {
  final ProfileController controller;

  const SwitchLane({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Obx(() => Container(
            height: 45,
            width: Get.width * 0.6,
            decoration: BoxDecoration(
              color: AppColors.greyShade,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment: controller.isPrivate.value
                      ? Alignment.centerRight // Private tab
                      : Alignment.centerLeft, // Public tab
                  child: Container(
                    width: (Get.width * 0.6) / 2,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.appColor, // Active tab color
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildSwitchTab("Public", false), // Now on the left
                    _buildSwitchTab("Private", true), // Now on the right
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildSwitchTab(String label, bool isPrivateTab) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.setPrivate(isPrivateTab);
        },
        child: Center(
          child: Obx(() {
            final isSelected = controller.isPrivate.value == isPrivateTab;
            return AppText(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.appColor,
            );
          }),
        ),
      ),
    );
  }
}
