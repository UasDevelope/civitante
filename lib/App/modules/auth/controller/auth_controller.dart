import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/constant.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../../utilse/toast_util.dart';
import '../../../utilse/uploadImage.dart';

class AuthController extends GetxController {
  RxBool obSecureText = RxBool(false);
  Rx<Position?> positioned = Rx<Position?>(null);
  RxBool isLocationFetched = RxBool(false);
  static final ImagePicker _picker = ImagePicker();

  ///<Login> Controllers
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPassworedController = TextEditingController();
  // <Forgot> Controlooers
  TextEditingController forgotPasswordController = TextEditingController();

  ///<Signup> Controllers
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController signupLocationController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController SignupConfirmPasswordController =
      TextEditingController();

  GlobalKey<FormState> signupGlobalKey = GlobalKey<FormState>();

  HttpService httpService = HttpService();

  RxBool loading = false.obs;

  RxBool prAccountloading = false.obs;

  RxString drivingLicense = RxString("");

  RxString passport = RxString("");

  final locationController = LocateController.locationController;

  TextEditingController ssNumber = TextEditingController();
  void changeObsecure() {
    obSecureText.value = !obSecureText.value;
    print(obSecureText.value);
  }

  Future<void> pickImage(String type) async {
    try {
      XFile? selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (selectedImage != null) {
        // Compress the image
        final XFile? compressedImage =
            await ImageUtils.compressImage(selectedImage);

        if (compressedImage != null) {
          // Upload the compressed image to Firebase Storage
          String imageUrl = await ImageUtils.uploadImageToFirebase(
              File(compressedImage.path));

          // Update the corresponding reactive variable with the image URL
          if (type == "1") {
            drivingLicense.value =
                imageUrl; // Reactive variable updated with the uploaded URL
            log("Driving License Image URL=====>$imageUrl");
          } else {
            passport.value =
                imageUrl; // Reactive variable updated with the uploaded URL
            log("Passport Image URL=====>$imageUrl");
          }
        } else {
          log("Image compression failed!");
        }
      } else {
        log("Oh Sorry...No Image Selected!");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  void goToNext(String route) {
    loading.value = true;

    Timer(Duration(seconds: 2), () {
      Get.toNamed(route);
      log('==============Redirecting to $route================>Routes-------->${route}');

      loading.value = false;
    });
  }

  void assignLocationValue() {
    signupLocationController.text =
        locationController.userLocation["locationName"];
  }

// Register Normal User
  void registerNormalUser() async {
    loading.value = true;
    var data = {
      "email": signupEmailController.text,
      "name": fullNameController.text,
      "location": {
        "long": locationController.longitude.value,
        "lat": locationController.latitude.value
      },
      "password": signupPasswordController.text,
      "costPoints": 10
    };

    var response = await HttpService.post('/register', data);

    if (response != null && response['error'] == null) {
      loading.value = false;
      ToastUtil.showToast(
        message: response['message'] ?? "Registration successful!",
        backgroundColor: Colors.green,
      );
      loading.value = false;

      goToNext(AppRoutes.login);
    } else {
      loading.value = false;
      String errorMsg = response['details'] != null
          ? jsonDecode(response['details'])['message']
          : "Unknown error occurred";

      ToastUtil.showToast(
        message: "Error: $errorMsg",
        backgroundColor: Colors.red,
      );
    }
  }

// Register Pro User
  void registerProUser() async {
    // Indicate loading state
    loading.value = true;

    // Prepare data for the API request
    var data = {
      "email": signupEmailController.text,
      "name": fullNameController.text,
      "location": {
        "long": positioned.value?.longitude, // Safely access longitude
        "lat": positioned.value?.latitude, // Safely access latitude
      },
      "password": signupPasswordController.text,
      "isPro": true,
      "ssn": ssNumber.text,
      "accountType": "test1",
      "drivingLicenseImage": drivingLicense.value,
      "passportImage": passport.value,
    };

    try {
      // Make the API request
      var response = await HttpService.post('/register', data);

      // Handle success response
      if (response != null && response['error'] == null) {
        loading.value = false;

        // Show success message
        ToastUtil.showToast(
          message: response['message'] ?? "Registration successful!",
          backgroundColor: Colors.green,
        );

        // Initiate payment process
        makePayment();
      } else {
        // Handle error response
        loading.value = false;
        String errorMsg = response['details'] != null
            ? jsonDecode(response['details'])['message']
            : "Unknown error occurred";

        ToastUtil.showToast(
          message: "Error: $errorMsg",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      // Handle exceptions
      loading.value = false;
      ToastUtil.showToast(
        message: "Error: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<Map<String, dynamic>> createSetupIntent() async {
    try {
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/setup_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_7MtY1LY7vRDC9GYPGOMl9EZv00pM9Eku1S',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      print('Setup Intent Response: ${response.body}');
      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating setup intent: ${err.toString()}');
      rethrow;
    }
  }

  Map<String, dynamic>? setupIntent;

  Future<void> makePayment() async {
    try {
      setupIntent = await createSetupIntent(); // Create setup intent
      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret:
              setupIntent!['client_secret'], // Use setupIntentClientSecret
          style: ThemeMode.dark,
          merchantDisplayName: 'Adnan',
        ),
      );

      // Display the payment sheet
      await displayPaymentSheet();
    } catch (e, s) {
      print('Exception during payment: $e $s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        print('Card details saved successfully!');

        // Fetch the updated setup intent
        if (setupIntent != null) {
          var updatedIntent =
              await retrieveSetupIntent(setupIntent!['client_secret']);
          if (updatedIntent != null) {
            print("here user id${AppConstant().userID}");
            savePaymentMethod(
                AppConstant().userID, updatedIntent['payment_method']);

            print('Payment Method ID: ${updatedIntent['payment_method']}');
          }
        }

        // Reset the setupIntent after successful card save
        setupIntent = null;
      }).onError((error, stackTrace) {
        print('Error displaying payment sheet: $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('StripeException: $e');
    } catch (e) {
      print('Error: $e');
    }
  }

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

      print('Updated Setup Intent Response: ${response.body}');
      return jsonDecode(response.body);
    } catch (err) {
      print('Error retrieving setup intent: ${err.toString()}');
      return null;
    }
  }

  void savePaymentMethod(String? userId, String token) async {
    var data = {
      "userId": userId,
      "paymentId": token,
    };

    var response = await HttpService.post('/savePaymentMethod', data);
    print('response: ${response}');
    if (response != null && response['error'] == null) {
      ToastUtil.showToast(
        message: response['message'] ?? "Payment method saved successfully!",
        backgroundColor: Colors.green,
      );
      upgradeToPro();
    } else {
      String errorMsg = response['details'] != null
          ? jsonDecode(response['details'])['message']
          : "Unknown error occurred";

      ToastUtil.showToast(
        message: "Error: $errorMsg",
        backgroundColor: Colors.red,
      );
    }
  }
  // update Pro user

  void upgradeToPro() async {
    print('Update User ${AppConstant().userID}');
    var data = {"userId": AppConstant().userID, "amount": 100};

    var response = await HttpService.post(AppConstant().charge, data);

    if (response != null && response['error'] == null) {
      goToNext(AppRoutes.login);
    } else {
      String errorMsg = response['details'] != null
          ? jsonDecode(response['details'])['message']
          : "Unknown error occurred";
      ToastUtil.showToast(
        message: "Error: $errorMsg",
        backgroundColor: Colors.red,
      );
    }
  }
  // Login Functions

  void loginUser() async {
    loading.value = true;
    var data = {
      "email": loginEmailController.text,
      "password": loginPassworedController.text,
    };

    var response = await HttpService.post('/login', data);

    if (response != null && response['error'] == null) {
      ToastUtil.showToast(
        message: response['message'] ?? "Login successful!",
        backgroundColor: Colors.green,
      );
      loading.value = false;

      PrefUtil.setString(PrefUtil.userId, response['user']['id']);
      // await SharedPreferencesHelper.saveUserId(response['user']['id']);
      //upgradeToPro();
      goToNext(AppRoutes.bottomNav);

      // Optional: Handle the returned user data
      var user = response['user'];
      print("User ID: ${user['id']}");
      print("Email: ${user['email']}");
    } else {
      String errorMsg = response['details'] != null
          ? jsonDecode(response['details'])['message']
          : "Unknown error occurred";

      ToastUtil.showToast(
        message: "Error: $errorMsg",
        backgroundColor: Colors.red,
      );
      loading.value = false;
    }
  }
}
