import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseScreen extends StatefulWidget {
  @override
  _InAppPurchaseScreenState createState() => _InAppPurchaseScreenState();
}

class _InAppPurchaseScreenState extends State<InAppPurchaseScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    if (_isAvailable) {
      await _loadProducts();
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdated,
        onError: _onPurchaseError,
      );
    } else {
      print("In-app purchases not available.");
    }
  }

  Future<void> _loadProducts() async {
    const Set<String> _productIds = {'poin100'};
    final response = await _inAppPurchase.queryProductDetails(_productIds);

    if (response.notFoundIDs.isNotEmpty) {
      print("Not found: ${response.notFoundIDs}");
    }
    print("found ${response.productDetails}");

    setState(() {
      _products = response.productDetails;
    });
  }

  void _buyProduct(ProductDetails product) {
    final purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          print("Purchase pending...");
          break;
        case PurchaseStatus.purchased:
          print("Purchase successful: ${purchase.productID}");
          _verifyPurchase(purchase);
          break;
        case PurchaseStatus.error:
          print("Purchase error: ${purchase.error}");
          break;
        case PurchaseStatus.restored:
          print("Purchase restored: ${purchase.productID}");
          break;
        default:
          break;
      }
    }
  }

  void _verifyPurchase(PurchaseDetails purchaseDetails) {
    // Server-side or Apple receipt verification logic would go here.
    _inAppPurchase.completePurchase(purchaseDetails);
    print("Purchase verified and completed: ${purchaseDetails.productID}");
  }

  void _onPurchaseError(Object error) {
    print("Purchase Stream Error: $error");
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('In-App Purchase')),
      body: _isAvailable
          ? _products.isNotEmpty
              ? ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (_, index) {
                    final product = _products[index];
                    return ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text(product.price),
                      onTap: () => _buyProduct(product),
                    );
                  },
                )
              : Center(child: Text('No products available.'))
          : Center(child: Text('In-App Purchases not available.')),
    );
  }
}
