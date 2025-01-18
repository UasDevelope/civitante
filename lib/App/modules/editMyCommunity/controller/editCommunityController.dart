import 'package:get/get.dart';

import 'package:get/get.dart';

class EditCommunityController extends GetxController {
  // Observable variables
  var communityName = ''.obs;
  var description = ''.obs;
  var selectedCategory = ''.obs;

  // List of categories
  final categories = ['Category 1', 'Category 2', 'Category 3'];

  // Function to delete the community
  void deleteCommunity() {
    // Add your delete logic here
    Get.snackbar('Delete', 'Community deleted successfully!');
  }

  // Function to save changes
  void saveChanges() {
    // Add your save logic here
    if (communityName.isEmpty || selectedCategory.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    Get.snackbar('Success', 'Changes saved successfully!');
  }
}

