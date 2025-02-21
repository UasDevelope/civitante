import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  // Google Sign-In
  Future<UserCredential?> googleSignInMethod() async {
    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication authentication =
          await googleUser.authentication;

      if (authentication.accessToken == null ||
          authentication.idToken == null) {
        print("Google Sign-In failed: Missing tokens");
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In Exception: $e");
      return null;
    }
  }

  // Apple Sign-In
  Future<UserCredential?> appleSignInMethod() async {
    try {
      var credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider("apple.com");
      final AuthCredential authCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      return await auth.signInWithCredential(authCredential);
    } catch (e) {
      print("Apple Sign-In Exception: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      print("Sign-Out Exception: $e");
    }
  }
}

// Common Sign-Out
