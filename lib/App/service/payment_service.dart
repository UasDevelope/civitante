import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import '../modules/loading/custom_loading_dialogue.dart';
import '../utilse/constant.dart';
import '../utilse/toast_util.dart';
import 'http_service.dart';

class PaymentService {
  Map<String, dynamic>? _setupIntent;

  /// Creates a Setup Intent on Stripe
  Future<bool> createSetupIntent() async {
    try {
     // CustomLoadingDialog.showCustomLoadingDialog("Creating setup intent...");

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/setup_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_7MtY1LY7vRDC9GYPGOMl9EZv00pM9Eku1S',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

     // CustomLoadingDialog.closeLoadingDialog();

      if (response.statusCode == 200) {
        _setupIntent = jsonDecode(response.body);
        print('✅ Setup Intent Created: ${response.body}');
        return true;
      } else {
        print('❌ Failed to create setup intent: ${response.body}');
        return false;
      }
    } catch (err) {
     // CustomLoadingDialog.closeLoadingDialog();
      print('❌ Error creating setup intent: $err');
      return false;
    }
  }

  /// Handles the entire payment process
  Future<bool> makePayment(BuildContext context) async {
    if (!await createSetupIntent())
      return false; // Ensure setup intent is created

    try {
     // CustomLoadingDialog.showCustomLoadingDialog("Initializing payment...");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: _setupIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Adnan',
        ),
      );

  //    CustomLoadingDialog.closeLoadingDialog();
      return await displayPaymentSheet(context);
    } catch (e, s) {
    //  CustomLoadingDialog.closeLoadingDialog();
      print('❌ Exception during payment setup: $e $s');
      return false;
    }
  }

  /// Displays the Stripe payment sheet
  Future<bool> displayPaymentSheet(BuildContext context) async {
    try {
     // CustomLoadingDialog.showCustomLoadingDialog(
        //  "Displaying payment sheet...");
      await Stripe.instance.presentPaymentSheet();

      print('✅ Card details saved successfully!');

      if (_setupIntent != null) {
        var updatedIntent =
            await retrieveSetupIntent(_setupIntent!['client_secret']);
        if (updatedIntent != null) {
          bool saved = await savePaymentMethod(
              AppConstant().userID!, updatedIntent['payment_method']);
          _setupIntent = null; // Reset after successful payment
          return saved;
        }
      }
      return false;
    } on StripeException catch (e) {
      print('❌ StripeException: $e');
      return false;
    } catch (e) {
      print('❌ Error displaying payment sheet: $e');
      return false;
    }
  }

  /// Retrieves the updated setup intent details from Stripe
  Future<Map<String, dynamic>?> retrieveSetupIntent(String clientSecret) async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://api.stripe.com/v1/setup_intents/${clientSecret.split("_secret")[0]}'),
        headers: {
          'Authorization': 'Bearer sk_test_7MtY1LY7vRDC9GYPGOMl9EZv00pM9Eku1S',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        print('✅ Retrieved Setup Intent: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('❌ Failed to retrieve setup intent: ${response.body}');
        return null;
      }
    } catch (err) {
      print('❌ Error retrieving setup intent: $err');
      return null;
    }
  }

  /// Saves the user's payment method to the backend
  Future<bool> savePaymentMethod(String userId, String token) async {
    try {
     // CustomLoadingDialog.showCustomLoadingDialog("Saving payment method...");
      var data = {"paymentId": token};

      var response = await HttpService.post('/savePaymentMethod', data);
    ///  CustomLoadingDialog.closeLoadingDialog();

      if (response != null && response['error'] == null) {
        ToastUtil.showToast(
          message: response['message'] ?? "Payment method saved successfully!",
          backgroundColor: Colors.green,
        );
        print('✅ Payment Method Saved: $token');
        return true;
      } else {
        String errorMsg = response['details'] != null
            ? jsonDecode(response['details'])['message']
            : "Unknown error occurred";

        ToastUtil.showToast(
          message: "Error: $errorMsg",
          backgroundColor: Colors.red,
        );
        print('❌ Failed to save payment method: $errorMsg');
        return false;
      }
    } catch (err) {
    //  CustomLoadingDialog.closeLoadingDialog();
      print('❌ Error saving payment method: $err');
      return false;
    }
  }
}
