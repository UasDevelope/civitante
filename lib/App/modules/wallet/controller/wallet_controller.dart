import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../Models/PointsResponse.dart';
import '../../../service/http_service.dart';
import '../../../utilse/toast_util.dart';

class WalletController extends GetxController {
  // Observables for toggling "See All"
  RxBool showMoreHistory = false.obs;
  var isloading = false.obs;
  RxBool showMorePostsHistory = false.obs;
  final _amountController = TextEditingController();
  var selectedAmount = 0.0.obs;
  final Rx<PointsResponse?> pointsData = Rx<PointsResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final double conversionRate = 10.0; // 1 USD = 10 points
  final List<Map<String, dynamic>> predefinedAmounts = [
    {'usd': 5.0, 'points': 50.0},
    {'usd': 10.0, 'points': 100.0},
    {'usd': 20.0, 'points': 200.0},
    {'usd': 50.0, 'points': 500.0},
    {'usd': 100.0, 'points': 1000.0},
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    // getPoints();
    loadPoints();
    super.onInit();
  }

  // Toggle "See All" for history and posts
  void toggleHistory() {
    showMoreHistory.value = !showMoreHistory.value;
  }

  void togglePostsHistory() {
    showMorePostsHistory.value = !showMorePostsHistory.value;
  }

  void selectPredefinedAmount(double usd) {
    selectedAmount.value = usd;
    _amountController.text = usd.toString();
  }

  void updateCustomAmount(String value) {
    selectedAmount.value = double.tryParse(value) ?? 0.0;
  }

  Future<void> loadPoints() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await getPoints();

      if (response.containsKey('error')) {
        errorMessage.value = response['error'];
      } else {
        print(response);
        pointsData.value = PointsResponse.fromJson(response);

      }
    } catch (e) {
      errorMessage.value = 'Failed to load points: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> buyPoints() async {
    //  isloading.value = true;
    if (selectedAmount.value <= 0) {
      return {'error': "Kindly enter amount"};
    } else {
      final points = selectedAmount.value * conversionRate;
      try {
        var response = await HttpService.post(
          '/buyPoints',
          {'points': points},
        );

        if (response != null && response['error'] == null) {
          isloading.value = false;
          print("Points purchased successfully: ${response}");
          return response; // Successful response
        } else {
          isloading.value = false;

          String errorMsg = response['details'] ?? "Unknown error occurred";
          ToastUtil.showToast(
            message: "Error: $errorMsg",
            backgroundColor: Colors.red,
          );
          return {'error': errorMsg};
        }
      } catch (e) {
        isloading.value = false;

        print("Exception in buyPoints: ${e.toString()}");
        ToastUtil.showToast(
          message: "Failed to buy points: ${e.toString()}",
          backgroundColor: Colors.red,
        );
        return {'error': e.toString()};
      }
    }
  }

  Future<Map<String, dynamic>> getPoints() async {
    try {
      var response = await HttpService.get('/getPoints');

      if (response != null && response['error'] == null) {

        return response; // Successful response
      } else {
        String errorMsg = response['details'] ?? "Unknown error occurred";
        ToastUtil.showToast(
          message: "Error: $errorMsg",
          backgroundColor: Colors.red,
        );
        return {'error': errorMsg};
      }
    } catch (e) {
      print("Exception in getPoints: ${e.toString()}");
      ToastUtil.showToast(
        message: "Failed to get points: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      return {'error': e.toString()};
    }
  }
}
