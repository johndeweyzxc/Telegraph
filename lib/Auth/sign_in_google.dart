import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegraph/Auth/auth_instance.dart';

class GoogleAuth {
  final googleSignIn = GoogleSignIn();

  Future<void> googleLogin() async {
    // A popup will show up to show user accounts
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    // Call google user to fetch authentication credentials
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // Use credential to sign in to firebase auth
    await AuthInstance().firebaseAuth.signInWithCredential(credential);
  }
}
