import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<UserCredential?> googleSignInMethod() async {
    try {
      // Ensure no existing sign-in
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication authentication =
      await googleUser.authentication;

      if (authentication.accessToken == null || authentication.idToken == null) {
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

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      print("Sign-Out Exception: $e");
    }
  }
}
