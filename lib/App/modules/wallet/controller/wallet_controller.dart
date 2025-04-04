import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../Models/PointsResponse.dart';
import '../../../service/http_service.dart';
import '../../../utilse/toast_util.dart';

class WalletController extends GetxController {
  RxBool showMoreHistory = false.obs;
  RxBool showMorePostsHistory = false.obs;
  var isLoading = false.obs;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  RxBool isProductLoading = false.obs;
  List<ProductDetails> products = [];
  RxBool isAvailable = false.obs;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final Rx<PointsResponse?> pointsData = Rx<PointsResponse?>(null);
  final RxString errorMessage = ''.obs;

  // Product IDs defined in app store (replace with your actual IDs)
  static const Set<String> _productIds = {
    'point50',
    'point100',
    'point200',
    'point500',
    'point1000',
  };

  @override
  void onInit() {
    loadPoints();
    _initializeInAppPurchase();
    super.onInit();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  Future<void> _initializeInAppPurchase() async {
    log("Inititializing");
    // Check if in-app purchase is available
    isAvailable.value = await _inAppPurchase.isAvailable();
    if (!isAvailable.value) {
      ToastUtil.showToast(
          message: "In-App Purchases not available.",
          backgroundColor: Colors.red);
      return;
    }

    // Listen to purchase updates
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen(_listenToPurchaseUpdates, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      ToastUtil.showToast(
          message: "Purchase error: $error", backgroundColor: Colors.red);
    });

    // Load products
    await loadProducts();
  }

  Future<void> loadProducts() async {
    isProductLoading.value = true;
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_productIds);
    if (response.error != null) {
      ToastUtil.showToast(
          message: "Error fetching products.", backgroundColor: Colors.red);
      products = [];
    } else {
      products = response.productDetails;
    }
    isProductLoading.value = false;
  }

  void buyProduct(ProductDetails product) {
    final existingPending = _inAppPurchase.purchaseStream.where((event) =>
        event.any((purchase) =>
            purchase.productID == product.id &&
            purchase.status == PurchaseStatus.pending));

    existingPending.listen((event) {
      ToastUtil.showToast(
        message: "A transaction is already pending for this product.",
        backgroundColor: Colors.orange,
      );
    });

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  void _listenToPurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        await _inAppPurchase.completePurchase(purchaseDetails);

        isLoading.value = true;
        ToastUtil.showToast(message: "Purchase pending...");
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        isLoading.value = false;
        ToastUtil.showToast(
            message: "Purchase failed: ${purchaseDetails.error?.message}",
            backgroundColor: Colors.red);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Verify purchase with your backend if needed
        await _verifyAndCreditPoints(purchaseDetails);
        await _inAppPurchase.completePurchase(purchaseDetails);
        isLoading.value = false;
        ToastUtil.showToast(message: "Purchase successful!");
        loadPoints(); // Refresh points after purchase
      }
    }
  }

  Future<void> _verifyAndCreditPoints(PurchaseDetails purchaseDetails) async {
    try {
      // Example: Send purchase token to your backend for verification
      final points = _getPointsFromProductId(purchaseDetails.productID);
      final response = await HttpService.post('/buyPoints', {
        // 'purchaseToken':
        //     purchaseDetails.verificationData.serverVerificationData,
        // 'productId': purchaseDetails.productID,
        'points': points,
      });

      loadPoints();
      Get.back();
      log("Response for this request is ${response}");
      if (response['error'] != null) {
        ToastUtil.showToast(
            message: "Error crediting points.", backgroundColor: Colors.red);
      }
    } catch (e) {
      ToastUtil.showToast(
          message: "Verification failed: $e", backgroundColor: Colors.red);
    }
  }

  int _getPointsFromProductId(String productId) {
    if (productId == 'point_50') return 50;
    if (productId == 'point_100') return 100;
    return 0;
  }

  Future<void> loadPoints() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await getPoints();
      if (response.containsKey('error')) {
        errorMessage.value = response['error'];
      } else {
        pointsData.value = PointsResponse.fromJson(response);
        pointsData.value?.paymentId = response['paymentId'] ?? false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load points: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getPoints() async {
    try {
      var response = await HttpService.get('/getPoints');
      if (response != null && response['error'] == null) {
        return response;
      } else {
        ToastUtil.showToast(
            message: "Error: ${response['details']}",
            backgroundColor: Colors.red);
        return {'error': response['details'] ?? "Unknown error"};
      }
    } catch (e) {
      ToastUtil.showToast(
          message: "Failed to get points: $e", backgroundColor: Colors.red);
      return {'error': e.toString()};
    }
  }

  void toggleHistory() => showMoreHistory.value = !showMoreHistory.value;
  void togglePostsHistory() =>
      showMorePostsHistory.value = !showMorePostsHistory.value;
}
