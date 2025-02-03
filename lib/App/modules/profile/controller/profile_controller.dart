import 'dart:developer';

import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/toast_util.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  RxString imageUrl = "".obs;
  String userId = PrefUtil.getString(PrefUtil.userId);
  RxBool isLoading = false.obs;
  Future<void> fetchProfileData() async {
    try {
      final response = await HttpService.get("/getProfile");
      nameController.text = response["name"];
      log("Response is $response");
    } catch (e) {
      ToastUtil.showToast(message: "$e");
    } finally {}
  }

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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProfileData();
  }
}
