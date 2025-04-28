import 'dart:developer';

import 'package:civitante/App/modules/loading/custom_loading_dialogue.dart';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/constant.dart';
import 'package:civitante/App/utilse/toast_util.dart';
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
      if (_validateInputs()) {
        CustomLoadingDialog.showCustomLoadingDialog("Adding Community....");

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

        log("the data for this is ==> ${data.toString()}");
        final response = await HttpService.post("/addCommunity", data);
        final controller = LocateController.myCommunities;
        controller.fetchCommunities();
        CustomLoadingDialog.closeLoadingDialog();
        Get.back();
        ToastUtil.showToast(message: "error!", backgroundColor: Colors.orange);
        log("Response for the add community  is ${response}");
      }
    } catch (e) {
      ToastUtil.showToast(message: "error!$e", backgroundColor: Colors.orange);
    }
  }

  /// **Validation Function**
  bool _validateInputs() {
    if (emailController.text.isEmpty) {
      ToastUtil.showToast(
          message: "Community name is required!",
          backgroundColor: Colors.orange);
      return false;
    }
    if (membership.value.isEmpty) {
      ToastUtil.showToast(
          message: "Membership type is required!",
          backgroundColor: Colors.orange);
      return false;
    }
    if (category.value.isEmpty) {
      ToastUtil.showToast(
          message: "Category is required!", backgroundColor: Colors.orange);
      return false;
    }
    if (interest.value.isEmpty) {
      ToastUtil.showToast(
          message: "At least one interest is required!",
          backgroundColor: Colors.orange);
      return false;
    }
    if (descriptionController.text.isEmpty) {
      ToastUtil.showToast(
          message: "Description is required!", backgroundColor: Colors.orange);
      return false;
    }
    if (communityImage.value.isEmpty) {
      ToastUtil.showToast(
          message: "Please upload a community image!",
          backgroundColor: Colors.orange);
      return false;
    }
    if (visibility.value.isEmpty) {
      ToastUtil.showToast(
          message: "Visibility setting is required!",
          backgroundColor: Colors.orange);
      return false;
    }
    return true;
  }
}
