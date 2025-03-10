
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async {
    // Check if biometrics can be used or the device supports authentication
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  static Future<bool> authenticate() async {
    try {
      // Check if authentication can be performed
      if (!await _canAuthenticate()) return false;

      // Perform authentication
      final result = await _auth.authenticate(
        localizedReason: 'Use Face ID Or Finger To Authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      // Log the success value
      log("Success: $result");

      return result;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable ||
          e.code == auth_error.notEnrolled ||
          e.code == auth_error.lockedOut) {
        // Handle specific errors related to authentication
        debugPrint('Authentication Error: $e');
      } else {
        debugPrint('Unknown Error: $e');
      }
      return false;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }
}
