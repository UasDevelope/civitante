import 'dart:developer';

import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/toast_util.dart';

import '../../../utilse/widgets.dart';

class EditCommunityController extends GetxController {
  // Observable variables
  final TextEditingController communityNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Reactive variables
  var selectedCategory = 'Technology'.obs;
  var imageUrl = ''.obs;

  // List of categories
  final categories = ['Technology', 'Health', 'AI', 'Art & Creativity'];

  void assignValue({
    required String name,
    required String image,
    required String category,
    required String desc,
  }) {
    communityNameController.text = name;
    descriptionController.text = desc;
    imageUrl.value = image;
    selectedCategory.value = category;
  }

  void saveChanges(String communityId) async {
    try {
      CustomLoadingDialog.showCustomLoadingDialog("Updating community");
      // Add your save logic here
      if (communityNameController.text.isEmpty || selectedCategory.isEmpty) {
        Get.snackbar('Error', 'Please fill all fields');
        return;
      }
      final response = await HttpService.put("/editCommunity/$communityId", {
        "description": descriptionController.text,
        "category": selectedCategory.value,
        "image": imageUrl.value,
        "name": communityNameController.text
      });
      final controller = LocateController.myCommunities;
      controller.fetchCommunities();
      CustomLoadingDialog.closeLoadingDialog();
      Get.back();
      Get.back();
      log("Response of edit community is $response");
    } catch (e) {
      CustomLoadingDialog.closeLoadingDialog();
      ToastUtil.showToast(message: "$e");
    } finally {}
  }

  Future<void> deleteCommunity(String communityId) async {
    try {
      CustomLoadingDialog.showCustomLoadingDialog("Deleting community...");
      final response = await HttpService.delete("/delCommunity/$communityId");
      final controller = LocateController.myCommunities;
      controller.fetchCommunities();
      CustomLoadingDialog.closeLoadingDialog();
      Get.back();
      Get.back();
      log("Response is $response");
    } catch (e) {
      CustomLoadingDialog.closeLoadingDialog();
      ToastUtil.showToast(message: "$e");
      log("Error during community delete $e");
    }
  }
}
