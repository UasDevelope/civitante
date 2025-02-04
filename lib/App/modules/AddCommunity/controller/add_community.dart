import 'dart:io';
import 'dart:developer';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/constant.dart';
import 'package:civitante/App/utilse/toast_util.dart';
import 'package:civitante/App/utilse/uploadImage.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';

class AddCommunityController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  RxString membership = ''.obs;
  RxString category = ''.obs;
  RxString interest = ''.obs;
  RxString visibility = ''.obs;
  RxString communityImage = ''.obs;

  RxBool isLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addCommunity() async {
    try {
      isLoading.value = true;
      final locationController = LocateController.locationController;

      String? userId = AppConstant().userID;
      log("User id is $userId");
      log("Location name is ${locationController.userLocation["locationName"]}");
      final data = {
        "name": emailController.text,
        "membership": membership.value.toLowerCase(),
        "category": category.value,
        "interests": [interest.value],
        "description": descriptionController.text,
        "image": communityImage.value,
        "visibility": {"location": visibility.value},
        "cost": 100,
        "createdBy": userId
      };
      final response = await HttpService.post("/addCommunity", data);
      Get.back();
      log("Response is ${response}");
    } catch (e) {
      ToastUtil.showToast(message: "$e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
