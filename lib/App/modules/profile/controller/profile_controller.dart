import 'dart:developer';

import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  String userId = PrefUtil.getString(PrefUtil.userId);
  RxBool isLoading = false.obs;
  Future<void> fetchProfileData() async {}

  Future<void> editUserProfile() async {
    try {
      isLoading.value = true;
      final locationController = LocateController.locationController;

      final data = {
        "name": nameController.text,
        "location": {
          "long": locationController.longitude.value,
          "lat": locationController.latitude.value
        },
        "costPoints": costController.text
      };
      final response = await HttpService.put("/editProfile/$userId", data);
      log("Response is $response");
      fetchProfileData();
    } catch (e) {
      log("The error during editProfile");
    } finally {
      isLoading.value = false;
    }
  }
}
