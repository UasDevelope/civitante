import 'dart:developer';
import 'package:get/get.dart';
import 'location_service.dart';

class LocationController extends GetxController {
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxMap<String, dynamic> userLocation = <String, dynamic>{}.obs;
  Future<void> fetchUserLocation() async {
    Map<String, dynamic> locationName =
    await LocationService.getCurrentLocation();
    final location = locationName["locationName"];
    log("Fetched location is $locationName");
    longitude.value = locationName["lng"];
    latitude.value = locationName["lat"];
    userLocation.value = location;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUserLocation();
  }
}
