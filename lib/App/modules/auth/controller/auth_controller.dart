import 'dart:developer';
import 'package:civitante/App/utilse/widgets.dart';

class AuthController extends GetxController {
  RxBool obSecureText = RxBool(false);
  Rx<Position?> positioned = Rx<Position?>(null);
  RxBool isLocationFetched = RxBool(false);
  static final ImagePicker _picker = ImagePicker();

  ///<Login> Controllers
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPassworedController = TextEditingController();
  GlobalKey<FormState> signupGlobalKey = GlobalKey<FormState>();

  RxBool loading = false.obs;
  RxBool prAccountloading = false.obs;
  RxString drivingLicense = RxString("");
  RxString passport = RxString("");

  // <Forgot> Controlooers
  TextEditingController forgotPasswordController = TextEditingController();

  ///<Signup> Controllers
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupLocationController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController SignupConfirmPasswordController =
      TextEditingController();
  TextEditingController ssNumber = TextEditingController();
  void changeObsecure() {
    obSecureText.value = !obSecureText.value;
    print(obSecureText.value);
  }

  Future<void> pickImage(String type) async {
    try {
      XFile? path = await _picker.pickImage(source: ImageSource.gallery);
      if (path != null) {
        if (type == "1") {
          drivingLicense.value = path.path; // Update the reactive variable
          log("Image Path=====>${drivingLicense.value}");
        } else {
          passport.value = path.path; // Update the reactive variable
          log("Image Path=====>${drivingLicense.value}");
        }
      } else {
        log("Oh Sorry...Image Path-----NULL______");
      }
    } catch (e) {
      log("Error:=>${e}");
    }
  }

  void goToNext(String route) {
    loading.value = true;

    Timer(Duration(seconds: 4), () {
      Get.toNamed(route);
      log('==============Redirecting to $route================>Routes-------->${route}');

      loading.value = false;
    });
  }

  fetchCurrentLocation() async {
    try {
      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      prAccountloading.value = true;

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log("===== Location permissions are denied =====>");
          prAccountloading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log("==== Location permission denied forever ====");
        prAccountloading.value = false;
        return;
      }

      // Get current position
      positioned.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get placemark details using latitude and longitude
      List<Placemark> placemarks = await placemarkFromCoordinates(
        positioned.value!.latitude,
        positioned.value!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        // Extract city, country, province, and street
        String city = place.locality ?? '';
        String country = place.country ?? '';
        String province = place.administrativeArea ?? '';
        String street = place.street ?? '';

        // Assign to location controller
        signupLocationController.text = "$street, $city, $province, $country";

        log("Location: ${signupLocationController.text}");
        prAccountloading.value = false;
      }
    } catch (e) {
      log("Error fetching location: $e");
    } finally {
      isLocationFetched.value = false;
    }
  }
}
