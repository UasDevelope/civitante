import 'package:civitante/App/utilse/toast_util.dart';
import 'package:civitante/App/utilse/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:developer' as lg;

class LocationService {
  static Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      // CustomLoadingDialog.showCustomLoadingDialog("Fetching user location");
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          ToastUtil.showToast(
              message: "Location permission denied by user",
              backgroundColor: Colors.red);
          throw Exception("Location permission denied by user.");
        }
      }

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      // Reverse geocode to get location details
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        String city = placemark.locality ?? "Unknown City";
        String state = placemark.administrativeArea ?? "Unknown State";
        String country = placemark.country ?? "Unknown Country";

        String locationName = placemark.name ?? "";

        // Log the location details
        lg.log(
            "Current location: Lat: ${position.latitude}, Lon: ${position.longitude}, Location Name: $locationName");
        // CustomLoadingDialog.closeLoadingDialog();
        return {
          'lng': position.longitude,
          'lat': position.latitude,
          'locationName': {
            "locationName": locationName,
            "city": city,
            "state": state,
            "country": country,
          },
        };
      } else {
        // CustomLoadingDialog.closeLoadingDialog();
        ToastUtil.showToast(
            message: "Unable to determine location name",
            backgroundColor: Colors.red);
        throw Exception("Unable to determine location name.");
      }
    } catch (e) {
      lg.log("Error fetching location: $e");
      ToastUtil.showToast(
          message: "Error fetching location: $e", backgroundColor: Colors.red);
      throw Exception("Failed to fetch location: $e");
    }
  }

  static Future<Map<String, dynamic>> getAddressFromCoordinates(
      double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      lng,
    );
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      return {
        'city': place.locality ?? '',
        'state': place.administrativeArea ?? '',
        'country': place.country ?? '',
        'locationName': place.name ?? "",
      };
    } else {
      return {};
    }
  }
}
