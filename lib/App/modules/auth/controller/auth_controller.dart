import 'dart:convert';
import 'dart:developer';

import 'package:civitante/App/service/http_service.dart';
import 'package:civitante/App/utilse/constant.dart';
import 'package:civitante/App/utilse/pref.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../../service/auth_services.dart';
import '../../../utilse/toast_util.dart';

class AuthController extends GetxController {
  RxInt currentTooltipIndex = 0.obs;

  final List<String> tooltipMessages = [
    "Welcome to the login screen!",
    "Enter your email or username",
    "Enter your password",
    "Check this box to stay logged in",
    "Click here if you forgot your password",
    "Press this button to log in",
    "Sign up if you don’t have an account"
  ];

  void nextTooltip() {
    if (currentTooltipIndex.value < tooltipMessages.length - 1) {
      currentTooltipIndex.value++;
    } else {
      currentTooltipIndex.value = -1; // Hide tooltips
    }
  }

  void skipTooltips() {
    currentTooltipIndex.value = -1;
  }

  RxBool obSecureText = RxBool(false);
  Rx<Position?> positioned = Rx<Position?>(null);
  RxBool isLocationFetched = RxBool(false);
  var isLoading = false.obs;
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

  var isRememberMeChecked = false.obs;

  void toggleRememberMe(bool? value) {
    if (value != null) {
      isRememberMeChecked.value = value;
    }
  }

  void goToNext(String route) {
    // loading.value = true;

    String displayRoute = route.replaceFirst("/", ""); // Removes leading "/"

    // Capitalize the first letter for better readability
    displayRoute = displayRoute[0].toUpperCase() + displayRoute.substring(1);

    //CustomLoadingDialog.showCustomLoadingDialog("Going to $displayRoute....");

    // Timer(Duration(seconds: 2), () {
    Get.toNamed(route);
    print('==============Redirecting to $route================>Routes-------->${route}');

    loading.value = false;
    // });
  }

  void assignLocationValue() {
    signupLocationController.text =
        locationController.userLocation["locationName"];
  }

// Register Normal User
  void registerNormalUser() async {
   try {
     loading.value = true;
     //  CustomLoadingDialog.showCustomLoadingDialog("Registering user...");
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
       ToastUtil.showToast(
         message: response['message'] ?? "Registration successful!",
         backgroundColor: Colors.green,
       );

       String token = response["user"]['token'];
       log("Response token is $token");
       PrefUtil.setString(PrefUtil.userId, token);
       AppConstant().userID = token;
       signupEmailController.clear();
       fullNameController.clear();
       signupLocationController.clear();
       signupPasswordController.clear();
       SignupConfirmPasswordController.clear();
       // CustomLoadingDialog.closeLoadingDialog();
       goToNext(AppRoutes.faceIDScreen);
     } else {
       //CustomLoadingDialog.closeLoadingDialog();
       String errorMsg = response['details'] != null
           ? jsonDecode(response['details'])['message']
           : "Unknown error occurred";

       ToastUtil.showToast(
         message: "Error: $errorMsg",
         backgroundColor: Colors.red,
       );
     }
   }
   catch(e){
     log("The error is $e");
   }
   finally{
     loading.value=false;
   }
  }

// Register Pro User
  void registerProUser() async {
    // Indicate loading state
    loading.value = true;
    //  CustomLoadingDialog.showCustomLoadingDialog("Registering Pro User...");

    // Prepare data for the API request
    var data = {
      "email": signupEmailController.text,
      "name": fullNameController.text,
      "location": {
        "long": locationController.longitude.value,
        "lat": locationController.latitude.value
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
        //   CustomLoadingDialog.closeLoadingDialog();
        // PrefUtil.setString(PrefUtil.userId, response["user"]["id"]);
        AppConstant().userID = response["user"]["id"];
        print("Response is $response");
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
        // CustomLoadingDialog.closeLoadingDialog();
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
      // CustomLoadingDialog.closeLoadingDialog();
      ToastUtil.showToast(
        message: "Error: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<Map<String, dynamic>> createSetupIntent() async {
    try {
      // CustomLoadingDialog.showCustomLoadingDialog("Creating setup intent...");
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/setup_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_7MtY1LY7vRDC9GYPGOMl9EZv00pM9Eku1S',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      print('Setup Intent Response: ${response.body}');
      // CustomLoadingDialog.closeLoadingDialog();
      return jsonDecode(response.body);
    } catch (err) {
      //  CustomLoadingDialog.closeLoadingDialog();
      rethrow;
    }
  }

  Map<String, dynamic>? setupIntent;

  Future<void> makePayment() async {
    try {
      setupIntent = await createSetupIntent(); // Create setup intent
      // Initialize the payment sheet
      // CustomLoadingDialog.showCustomLoadingDialog("Making payment...");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret:
              setupIntent!['client_secret'], // Use setupIntentClientSecret
          style: ThemeMode.dark,
          merchantDisplayName: 'Adnan',
        ),
      );
      //  CustomLoadingDialog.closeLoadingDialog();
      // Display the payment sheet
      await displayPaymentSheet();
    } catch (e, s) {
      // CustomLoadingDialog.closeLoadingDialog();
      print('Exception during payment: $e $s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      // CustomLoadingDialog.showCustomLoadingDialog(
      //  "Displaying payment sheet...");
      await Stripe.instance.presentPaymentSheet().then((value) async {
        print('Card details saved successfully!');

        // Fetch the updated setup intent
        if (setupIntent != null) {
          var updatedIntent =
              await retrieveSetupIntent(setupIntent!['client_secret']);
          if (updatedIntent != null) {
            // CustomLoadingDialog.closeLoadingDialog();
            savePaymentMethod(
                AppConstant().userID!, updatedIntent['payment_method']);

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

  void savePaymentMethod(String userId, String token) async {
    // CustomLoadingDialog.showCustomLoadingDialog("Saving payment method...");
    var data = {
      "userId": userId,
      "paymentId": token,
    };
    print("data is $data");

    var response = await HttpService.post('/savePaymentMethod', data);
    print('response: ${response}');
    if (response != null && response['error'] == null) {
      // CustomLoadingDialog.closeLoadingDialog();
      ToastUtil.showToast(
        message: response['message'] ?? "Payment method saved successfully!",
        backgroundColor: Colors.green,
      );
      upgradeToPro();
    } else {
      //   CustomLoadingDialog.closeLoadingDialog();
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
    //   CustomLoadingDialog.showCustomLoadingDialog("Upgrading To Pro....");
    print('Update User ${AppConstant().userID}');
    var data = {"userId": AppConstant().userID, "amount": 100};

    var response = await HttpService.post(AppConstant().charge, data);

    if (response != null && response['error'] == null) {
      //   CustomLoadingDialog.closeLoadingDialog();
      goToNext(AppRoutes.login);
    } else {
      //CustomLoadingDialog.closeLoadingDialog();
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

    /// CustomLoadingDialog.showCustomLoadingDialog("Logging in user....");
    var data = {
      "email": loginEmailController.text,
      "password": loginPassworedController.text,
    };

    var response = await HttpService.post('/login', data);
    print(response);
    if (response != null && response['error'] == null) {
      ToastUtil.showToast(
        message: response['message'] ?? "Login successful!",
        backgroundColor: Colors.green,
      );
      String token = response['token'];

      PrefUtil.setString(PrefUtil.userId, token);
      AppConstant().userID = token;

      loading.value = false;
      // await SharedPreferencesHelper.saveUserId(response['user']['id']);
      //upgradeToPro();
      loginEmailController.clear();
      loginPassworedController.clear();
      goToNext(AppRoutes.bottomNav);

      // Optional: Handle the returned user data
      var user = response['user'];
      print("User ID: ${user['id']}");
      print("Email: ${user['email']}");
    } else {
      loading.value = false;

      // CustomLoadingDialog.closeLoadingDialog();
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

  final AuthServices authService = AuthServices();
  var user = Rxn<UserCredential>();

  Future<void> loginWithGoogle() async {
    try {
      loading.value = true;
      user.value = await authService.googleSignInMethod();

      if (user.value != null) {
        User? firebaseUser = user.value?.user;
        String? email = firebaseUser?.email;
        String? accessToken = await firebaseUser?.getIdToken();
        var data = {
          "email": email,
          "password": accessToken,
        };

        var response = await HttpService.post('/login', data);
        print(response);
        if (response != null && response['error'] == null) {
          ToastUtil.showToast(
            message: response['message'] ?? "Login successful!",
            backgroundColor: Colors.green,
          );
          String token = response['token'];

          PrefUtil.setString(PrefUtil.userId, token);
          AppConstant().userID = token;

          loading.value = false;
          goToNext(AppRoutes.bottomNav);
        } else {
          loading.value = false;
          String errorMsg = response['details'] != null
              ? jsonDecode(response['details'])['message']
              : "Unknown error occurred";

          ToastUtil.showToast(
            message: "Error: $errorMsg",
            backgroundColor: Colors.red,
          );
          loading.value = false;
        }
        print("User Info: Email: $email, Token: $accessToken");
      } else {
        ToastUtil.showToast(
          message: "Google Sign-In Failed",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      loading.value = true;
      user.value = await authService.googleSignInMethod();

      if (user.value != null) {
        User? firebaseUser = user.value?.user;
        String? fullName = firebaseUser?.displayName;
        String? email = firebaseUser?.email;
        String? accessToken = await firebaseUser?.getIdToken();
        var data = {
          "email": email,
          "name": fullName,
          "location": {
            "long": locationController.longitude.value,
            "lat": locationController.latitude.value
          },
          "password": accessToken,
          "costPoints": 10
        };
        var response = await HttpService.post('/register', data);
        print(response);
        if (response != null && response['error'] == null) {
          ToastUtil.showToast(
            message: response['message'] ?? "Signup successful!",
            backgroundColor: Colors.green,
          );
          String token = response['token'];
          PrefUtil.setString(PrefUtil.userId, token);
          AppConstant().userID = token;
          loading.value = false;
          goToNext(AppRoutes.faceIDScreen);
        } else {
          loading.value = false;
          String errorMsg = response['details'] != null
              ? jsonDecode(response['details'])['message']
              : "Unknown error occurred";

          ToastUtil.showToast(
            message: "Error: $errorMsg",
            backgroundColor: Colors.red,
          );
          loading.value = false;
        }

        // Log the data
        print("User Info: Full Name: $fullName, Email: $email, Token: $accessToken");
      } else {
        ToastUtil.showToast(
          message: "Google Sign-Up Failed",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> signUpWithApple() async {
    try {
      loading.value = true;
      user.value = await authService.appleSignInMethod();

      if (user.value != null) {
        User? firebaseUser = user.value?.user;
        String? fullName = firebaseUser?.displayName;
        String? email = firebaseUser?.email;
        String? accessToken = await firebaseUser?.getIdToken();
        var data = {
          "email": email,
          "name": fullName ?? 'Demo',
          "location": {
            "long": locationController.longitude.value,
            "lat": locationController.latitude.value
          },
          "password": accessToken,
          "costPoints": 10
        };
        print('Daata here : $data');
        var response = await HttpService.post('/register', data);
        print(response);
        if (response != null && response['error'] == null) {
          ToastUtil.showToast(
            message: response['message'] ?? "Signup successful!",
            backgroundColor: Colors.green,
          );
          String token = response['user']['token'];

          PrefUtil.setString(PrefUtil.userId, token);
          AppConstant().userID = token;
          loading.value = false;
          goToNext(AppRoutes.bottomNav);
        } else {
          loading.value = false;
          String errorMsg = response['details'] != null
              ? jsonDecode(response['details'])['message']
              : "Unknown error occurred";

          ToastUtil.showToast(
            message: "Error: $errorMsg",
            backgroundColor: Colors.red,
          );
          loading.value = false;
        }

        // Log the data
       // log("User Info: Full Name: $fullName, Email: $email, Token: $accessToken");
      } else {
        ToastUtil.showToast(
          message: "Apple Sign-Up Failed",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> loginWithApple() async {
    try {
      loading.value = true;
      user.value = await authService.appleSignInMethod();

      if (user.value != null) {
        User? firebaseUser = user.value?.user;
        String? email = firebaseUser?.email;
        String? accessToken = await firebaseUser?.getIdToken();
        var data = {
          "email": email,
          "password": accessToken,
        };

        var response = await HttpService.post('/login', data);
        print(response);
        if (response != null && response['error'] == null) {
          ToastUtil.showToast(
            message: response['message'] ?? "Login successful!",
            backgroundColor: Colors.green,
          );
          String token = response['token'];

          PrefUtil.setString(PrefUtil.userId, token);
          AppConstant().userID = token;

          loading.value = false;
          goToNext(AppRoutes.bottomNav);
        } else {
          loading.value = false;
          String errorMsg = response['details'] != null
              ? jsonDecode(response['details'])['message']
              : "Unknown error occurred";

          ToastUtil.showToast(
            message: "Error: $errorMsg",
            backgroundColor: Colors.red,
          );
          loading.value = false;
        }
        log("User Info: Email: $email, Token: $accessToken");
      } else {
        ToastUtil.showToast(
          message: "Google Sign-In Failed",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      loading.value = false;
    }
  }
}
